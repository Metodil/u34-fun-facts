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
    bucket         = "u34-tfstate"
    key            = "common.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "u34-lock"
  }
}
