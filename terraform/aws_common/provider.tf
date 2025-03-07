# first create manuel s3 bucket : u34-tfstate
# then import
# terraform import 'aws_s3_bucket.terraform_state' u34-tfstate

terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.80.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
