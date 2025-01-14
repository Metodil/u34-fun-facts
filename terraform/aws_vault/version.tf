terraform {
  backend "s3" {
    bucket         = "u34-tfstate"   #"${var.bucket_name}"
    key            = "vault.tfstate" #"${var.aws_s3_state_common_name}" #var.aws_s3_state_common_name
    region         = "eu-central-1"  #"${var.aws_region}" #var.aws_region
    dynamodb_table = "u34-lock"      #"${var.aws_db_lock_state_name}" #var.aws_db_lock_state_name
  }
}
