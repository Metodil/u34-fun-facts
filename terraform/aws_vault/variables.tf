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

variable "aws_s3_state_common_name" {
  type        = string
  default     = "common.tfstate"
  description = "value of the s3 state name"
}

variable "aws_s3_state_eks_name" {
  type        = string
  default     = "eks.tfstate"
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

variable "instance_type" {
  description = "AWS Instance Type (EC2 Type)"
  default     = "t2.micro"
}

variable "instance_key_name" {
  description = "AWS Instance Key Name"
  default     = "vault-aws-key"
}

variable "environments" {
  type        = any
  default     = "dev"
  description = "The environment configuration"
}
