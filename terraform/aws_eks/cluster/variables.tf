variable "aws_region" {
  type        = any
  default     = "eu-central-1"
  description = "value of the region where the resources will be created"
}

variable "cluster_name" {
  default     = "u34-k8s"
  description = "the name of the cluster"
}

variable "instance_type" {
  default     = "t3.midium"
  description = "default instance type"
}

variable "vpc_id" {
  default = "vpc_id"
}

variable "public_subnets" {
  default = "public_subnets"
}

variable "vpc_name" {
  default     = "k8s-vpc"
  description = "default value of vpc"
}

variable "vpc_subnet_name" {
  default     = "k8s-vpc-public-eu-central-1a"
  description = "default value of vpc subnet name"
}


variable "default_tags" {
  default = "u34_fp"
}

variable "eks_access_entries" {
  type = any
}
