# That will automatically create a Kubernetes Secret with:
# apiVersion: v1
# kind: Secret
# metadata:
#   name: secret-fun-facts
# type: Opaque
# stringData:
#   DB_USER: <name>
#   DB_PASS: <password>
#   DB_ROOT_PASSWORD: <root-password>
resource "kubernetes_manifest" "ext-sec-u34-fun-facts" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "ExternalSecret"
    "metadata" = {
      "name"      = "vault-u34-fun-facts-secrets"
      "namespace" = "${var.kubernetes_app_namespace}"
    }
    "spec" = {
      "refreshInterval" = "15s"
      "secretStoreRef" = {
        "name" = "vault-backend"
        "kind" = "SecretStore"
      }
      "target" = {
        "name" = "secret-fun-facts"
      }
      "data" = [
        {
          "secretKey" = "DB_USER"
          "remoteRef" = {
            "key"      = "database"
            "property" = "DB_USER"
          }
        },
        {
          "secretKey" = "DB_PASS"
          "remoteRef" = {
            "key"      = "database"
            "property" = "DB_PASS"
          }
        },
        {
          "secretKey" = "DB_ROOT_PASSWORD"
          "remoteRef" = {
            "key"      = "database"
            "property" = "DB_ROOT_PASSWORD"
          }
        },
      ]
    }
  }
  depends_on = [kubernetes_manifest.secret_store]
}
