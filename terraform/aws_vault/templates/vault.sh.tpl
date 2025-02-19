#!/bin/bash

set -xe

# Send userdata to log
[[ ! -d /var/log/userdata ]] && mkdir -p /var/log/userdata/
exec > >(tee /var/log/userdata/userdata.log | logger -t user-data -s 2>/dev/console) 2>&1


# Login profile picked up when users login to the instance
cat << EOF > /etc/profile.d/vault.sh
export VAULT_ADDR="https://vault.u34-vault.link:8200"
EOF

export VAULT_ADDR="https://vault.u34-vault.link:8200"

# create vault certificate with certbot
certbot certonly --standalone -d vault.u34-vault.link
cp /etc/letsencrypt/live/vault.u34-vault.link/fullchain.pem /opt/vault/tls/server.crt
cp /etc/letsencrypt/live/vault.u34-vault.link/privkey.pem /opt/vault/tls/server.key
chown vault:vault /opt/vault/tls/server.crt /opt/vault/tls/server.key
chmod 700 /opt/vault/tls/server.crt /opt/vault/tls/server.key
# uncomment tls
sed -i '/server\.crt/s/^#//g'  /etc/vault.hcl
sed -i '/server\.key/s/^#//g'  /etc/vault.hcl
sed -i 's/tls_disable \= 1/tls_disable \= 0/g'  /etc/vault.hcl
#coment http and uncomment https
sed -i '/http\:\/\/127/s/^/#/g'  /etc/vault.hcl
sed -i '/https/s/^#//g'  /etc/vault.hcl



# set aws kms  for auto unseal
sed -i '/awskms/s/^#//g'  /etc/vault.hcl
systemctl restart vault
# unseal vault with migrate
egrep -m3 '^    "' /opt/vault/data/init_data.json | tr -d ' ' | cut -c 2- | rev | cut -c 3- | rev | while read key; do   vault operator unseal -migrate ${key}; done

# Get the VAULT_TOKEN so we can interact with vault
export VAULT_TOKEN=$(jq -r '.root_token' /opt/vault/data/init_data.json)
# Get the unseal key
export UNSEAL_KEY=$(jq -r '.unseal_keys_b64 | .[] ' /opt/vault/data/init_data.json)
# Save the root token and unseal key to aws secrets manager, then we can delete ~/vault-init-out.txt
# The secret resources have already been created by terraform (secrets-manager.tf)
aws secretsmanager update-secret --secret-id ${secret_token_id} --secret-string  "$${VAULT_TOKEN}" --region ${region}
aws secretsmanager update-secret --secret-id ${secret_unseal_id} --secret-string "$${UNSEAL_KEY}" --region ${region}

# Remove the temp file which has the root token details
# rm -f ~/vault-init-out.txt

#    # Vault already initialised, which means the db is up which has our role, so login with that role, then exit this script.
#    echo "[] Vault DB already initialised. Check we can login with aws method and exit"
#    vault login -method=aws role=admin
#    echo "[] Userdata finished."
#    exit


# Enable the vault AWS and kv engine
vault auth enable aws
vault secrets enable -path=secret -version=2 kv

# Get the vault-admin-policy.hcl file that was uploaded to S3 in s3.tf
aws s3 cp s3://${vault_bucket}/vault-admin-policy.hcl /var/tmp/

## Create the admin policy in vault
#vault policy write "admin-policy" /var/tmp/vault-admin-policy.hcl

## Give this instance admin privileges to vault, tied to this instances vault_instance_role.
#vault write \
#    auth/aws/role/admin \
#    auth_type=iam \
#    policies=admin-policy \
#    max_ttl=1h \
#    bound_iam_principal_arn=${vault_instance_role}
