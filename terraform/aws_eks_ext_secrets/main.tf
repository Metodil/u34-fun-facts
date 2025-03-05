data "aws_eks_cluster" "cluster" {
  name = "u34-dev"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "u34-dev"
}

#locals {
#  external_values = templatefile("configs/values.yaml.tftpl", {
#    fullnameOverride = "external-secrets"
#    })
#}
#

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = var.kubernetes_app_namespace
  }
}

variable "SECRET_ID" {
  type = string
}

resource "kubernetes_secret" "role_secret_id" {
  metadata {
    name      = "u34-fun-facts-role-secret-id-1"
    namespace = var.kubernetes_app_namespace
  }
  data = {
    secret-id = var.SECRET_ID
  }
  type       = "kubernetes.io/opaque"
  depends_on = [kubernetes_namespace.app_namespace]
}

resource "helm_release" "external_secret_operator" {
  name       = "external-secret-operator"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = var.kubernetes_app_namespace
  version    = "v0.14.3"
  #  values = [local.external_values]
  depends_on = [kubernetes_namespace.app_namespace]
}
