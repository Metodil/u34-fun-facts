#terraform {
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = ">= 5.80.0"
#    }
#  }
#}

terraform {
  backend "s3" {
    bucket         = "u34-tfstate"
    key            = "eks_add_ons.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "u34-lock"
  }
}
