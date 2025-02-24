#!/bin/bash

set -xe

# Send userdata to log
[[ ! -d /var/log/userdata ]] && mkdir -p /var/log/userdata/
exec > >(tee /var/log/userdata/userdata.log | logger -t user-data -s 2>/dev/console) 2>&1

# Login profile picked up when users login to the instance
cat << EOF > /etc/profile.d/vault.sh
export VAULT_ADDR=http://127.0.0.1:8200
export AWS_REGION=${region}
export VAULT_BUCKET=${vault_bucket}
export VAULT_DYNAMODB_TABLE=${vault_dynamodb-table}
export VAULT_INSTANCE_ROLE=${vault_instance_role}
export VAULT_KMS_KEY=${vault_kms_key}
export VAULT_FQDN=${vault_fqdn}
export VAULT_SECRET_TOKEN_ID=${secret_token_id}
export VAULT_SECRET_UNSEAL_ID=${secret_unseal_id}
export LETSENCRYPT_MAIL=${letsencript-mail}
EOF

# Set new vault config file
cat > /etc/vault.hcl <<-EOF
api_addr="http://127.0.0.1:8200"
cluster_addr="http://127.0.0.1:8201"

ui=true
disable_mlock = true

default_lease_ttl = "168h"
max_lease_ttl = "720h"

log_file = "/var/log/vault.log"
log_rotate_duration = "24h"
log_rotate_max_files = 30

listener "tcp" {
	address     = "0.0.0.0:8200"
	tls_disable = 1
#    tls_cert_file = "/opt/vault/tls/server.crt"
#    tls_key_file  = "/opt/vault/tls/server.key"
}

#api_addr="https://${vault_fqdn}:8200"
#cluster_addr="https://${vault_fqdn}:8201"

storage "dynamodb" {
  region = "${region}"
  table = "${vault_dynamodb-table}"
  read_capacity = 3
  write_capacity = 3
}

seal "awskms" {
  region = "${region}"
  kms_key_id = "${unseal-key}"
}
EOF

systemctl start vault
# Wait for vault to start
sleep 30s

export VAULT_ADDR=http://127.0.0.1:8200

# Initialise vault and save token and unseal key
vault operator init -recovery-shares=1 -recovery-threshold=1 2>&1 | tee ~/vault-init-out.txt
vault status | tee -a ~/vault-status.txt

# Get the VAULT_TOKEN so we can interact with vault
export VAULT_TOKEN=$(grep '^Initial Root Token:' ~/vault-init-out.txt | awk '{print $NF}')
# Get the unseal key
export RECOVERY_KEY=$(grep '^Recovery Key' ~/vault-init-out.txt | awk '{print $NF}')

# Save the root token and recovery key to aws secrets manager, then we can delete ~/vault-init-out.txt
# The secret resources have already been created by terraform (secrets-manager.tf)
aws secretsmanager update-secret --secret-id ${secret_token_id} --secret-string  "$${VAULT_TOKEN}" --region ${region}
aws secretsmanager update-secret --secret-id ${secret_unseal_id} --secret-string "$${RECOVERY_KEY}" --region ${region}

# Remove the temp file which has the root token details
rm -f ~/vault-init-out.txt

# Enable the vault AWS and kv engine
vault auth enable aws
vault secrets enable -path=secret -version=2 kv

# Get the vault-admin-policy.hcl file that was uploaded to S3 in s3.tf
aws s3 cp s3://${vault_bucket}/vault-admin-policy.hcl /var/tmp/
# Create the admin policy in vault
vault policy write "admin-policy" /var/tmp/vault-admin-policy.hcl
# Give this instance admin privileges to vault, tied to this instances vault_instance_role.
vault write \
    auth/aws/role/admin \
    auth_type=iam \
    policies=admin-policy \
    max_ttl=1h \
    bound_iam_principal_arn=${vault_instance_role}

# Login profile picked up when users login to the instance
cp /etc/profile.d/vault.sh /etc/profile.d/vault.sh.bak
echo "export VAULT_ADDR=https://${vault_fqdn}:8200" > /etc/profile.d/vault.sh
export VAULT_ADDR="https://${vault_fqdn}:8200"

# Wait for FQDN to be available
sleep 30s
IP=$(dig +short ${vault_fqdn})

# Create vault certificate with certbot
certbot certonly --standalone --non-interactive --agree-tos -m ${letsencript-mail} -d ${vault_fqdn}
cp /etc/letsencrypt/live/${vault_fqdn}/fullchain.pem /opt/vault/tls/server.crt
cp /etc/letsencrypt/live/${vault_fqdn}/privkey.pem /opt/vault/tls/server.key
chown vault:vault /opt/vault/tls/server.crt /opt/vault/tls/server.key
chmod 700 /opt/vault/tls/server.crt /opt/vault/tls/server.key

# TODO: Add cron job to renew cert

# Uncomment tls
sed -i '/server\.crt/s/^#//g'  /etc/vault.hcl
sed -i '/server\.key/s/^#//g'  /etc/vault.hcl
sed -i 's/tls_disable \= 1/tls_disable \= 0/g'  /etc/vault.hcl
# Coment http and uncomment https
sed -i '/http\:\/\/127/s/^/#/g'  /etc/vault.hcl
sed -i '/https/s/^#//g'  /etc/vault.hcl
sed -i 's/http\:\/\/127\.0\.0\.1/https\:\/\/${vault_fqdn}/g' /etc/profile.d/vault.sh

# Restart vault
systemctl restart vault
