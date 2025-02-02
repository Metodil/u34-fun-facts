resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = var.aws_db_lock_state_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  #checkov:skip=CKV_AWS_119: "Ensure DynamoDB Tables are encrypted using a KMS Customer Managed CMK"
  #checkov:skip=CKV_AWS_28: "Ensure DynamoDB point in time recovery (backup) is enabled"
  #checkov:skip=CKV2_AWS_16: "Ensure that Auto Scaling is enabled on your DynamoDB tables"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = var.aws_db_lock_state_name
    Description = "This dynamodb table is used for locking terraform state."
    env         = var.env_name
  }

  lifecycle {
    prevent_destroy = true
  }
}
