variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "value of the region where the resources will be created"
}

variable "bucket_name" {
  type        = string
  default     = "u34-tfstate"
  description = "The bucket to use for storing terrform state files"
}

variable "vault_fqdn" {
  description = "FQDN of vault instace for tls"
  type        = string
  default     = "https://vault.u34-vault.link:8200"
}

variable "vault_secret_path" {
  description = "Secret path in vault instace"
  type        = string
  default     = "u34-fun-facts"
}

variable "kubernetes_app_namespace" {
  description = "Name of kubernetes namespace where the app is deployed"
  type        = string
  default     = "u34-fun-facts"
}
