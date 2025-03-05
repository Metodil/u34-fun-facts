resource "kubernetes_manifest" "secret_store" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "SecretStore"
    "metadata" = {
      "name"      = "vault-backend"
      "namespace" = "${var.kubernetes_app_namespace}"
    }
    "spec" = {
      "provider" = {
        "vault" = {
          "server"  = "${var.vault_fqdn}"
          "version" = "v2"
          "path"    = "${var.vault_secret_path}"
          "auth" = {
            "appRole" = {
              # Path where the App Role authentication backend is mounted
              "path" = "approle"
              # RoleID configured in the App Role authentication backend
              "roleId" = "2c9f72d1-3e2a-6136-104b-99b4b6bad891"
              # Reference to a key in a Secret that contains the App Role SecretId
              "secretRef" = {
                "name" = "u34-fun-facts-role-secret-id"
                "key"  = "secret-id"
              }
            }
          }
        }
      }
    }
  }
  depends_on = [helm_release.external_secret_operator]
}
# Hints:
#     version: "v2"
#       Version is the Vault KV secret engine version.
#       This can be either "v1" or "v2", defaults to "v2"
#      auth:
#         points to a secret that contains a vault token
#         https://www.vaultproject.io/docs/auth/token
