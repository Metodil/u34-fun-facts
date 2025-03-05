## Use Externa secrets in Kubernetes to get secret from Hashi Vault


### Using Terraform for creating secrets from Hashi Vault

> - *main.tf* - *main file* for creating:
    - application namespace
    - secret for secret_id
    - external secrets module
> - *secret-store.tf* - creating secret-store with AppRole auth method
> - *external-secrets-sets.tf* - extracting secrets from vault and creating secrets for database access

### Set github secret and use in github actions
### as environment variable *TF_VAR_SECRET_ID=secret-id*
***
### On Hashi Vault instance
Using
```bash
# AppRole auth method

# u34-fun-facts policy in policy_u34-fun-facts.hcl
path "u34-fun-facts/*" {
  capabilities = [ "read", "list" ]
}
vault policy write u34-fun-facts policy_u34-fun-facts.hcl
# verify
vault policy read u34-fun-facts

# create u34-fun-facts-role role
vault write auth/approle/role/u34-fun-facts-role \
  policies="u34-fun-facts" \
  token_ttl="1h" \
  token_max_ttl="4h"
# verify
vault read auth/approle/role/u34-fun-facts-role

# set environment vars
ROLE_ID=$(vault read auth/approle/role/u34-fun-facts-role/role-id -format=json \
  | jq -r .data.role_id
)
SECRET_ID=$(vault write -f auth/approle/role/u34-fun-facts-role/secret-id -format=json \
  | jq -r .data.secret_id)

VAULT_DGRAPH_TOKEN=$(vault write auth/approle/login \
  role_id="$ROLE_ID" \
  secret_id="$SECRET_ID" \
  --format=json \
  | jq -r .auth.client_token
)
# login with new token
vault login $VAULT_DGRAPH_TOKEN
# verify
vault kv get u34-fun-facts/atabase
```
