# first create manuel s3 bucket : u34-tfstate
# then import
# terraform import 'aws_s3_bucket.terraform_state' u34-tfstate

provider "aws" {
  region = var.aws_region
}
