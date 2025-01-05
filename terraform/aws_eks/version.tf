terraform {
  backend "s3" {
    bucket         = "u34-tfstate"
    key            = "eks.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "u34-lock"
  }
}
