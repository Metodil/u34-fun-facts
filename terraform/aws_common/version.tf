terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.80.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = var.bucket-name
    key            = var.aws_s3_state_common_name
    region         = var.aws_region
    dynamodb_table = var.aws_db_lock_state_name
  }
}
