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

variable "force_destroy" {
  default = false
}

variable "aws_s3_state_common_name" {
  type        = string
  default     = "common.tfstate"
  description = "value of the s3 state name"
}

variable "aws_db_lock_state_name" {
  type        = string
  default     = "u34-lock"
  description = "value of the dynamodb table lock name"
}

variable "env_name" {
  type        = string
  default     = "dev"
  description = "Environment name"
}

variable "vpc_name" {
  default     = "k8s-vpc"
  description = "default value of vpc"
}

variable "cluster_name" {
  default     = "k8s-eks"
  description = "default value of eks cluster"
}
