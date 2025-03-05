terraform {
  backend "s3" {
    bucket         = "u34-tfstate"
    key            = "eks_ext_secrets.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "u34-lock"
  }
}
