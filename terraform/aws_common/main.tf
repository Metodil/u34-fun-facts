# first create manuel s3 bucket : u34-tfstate
# then import
# terraform import 'aws_s3_bucket.terraform_state' u34-tfstate

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  #checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
  #checkov:skip=CKV_AWS_145: "Ensure that S3 buckets are encrypted with KMS by default"
  #checkov:skip=CKV2_AWS_16: "Ensure that Auto Scaling is enabled on your DynamoDB tables"
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  #checkov:skip=CKV2_AWS_61 "Ensure that an S3 bucket has a lifecycle configuration"
  #checkov:skip=CKV2_AWS_62: "Ensure S3 buckets should have event notifications enabled"
  #checkov:skip=CKV_AWS_28: "Ensure DynamoDB point in time recovery (backup) is enabled"

  force_destroy = var.force_destroy
  tags = {
    Name        = var.bucket_name
    Description = "This bucket is used for storing terraform state."
    tags        = "terraform"
    env         = var.env_name
  }

  lifecycle {
    prevent_destroy = true
  }

}


resource "aws_s3_bucket_server_side_encryption_configuration" "encrypting_bicket" {
  bucket = aws_s3_bucket.terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.terraform_state.json
}

data "aws_iam_policy_document" "terraform_state" {
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.terraform_state.id}",
      "arn:aws:s3:::${aws_s3_bucket.terraform_state.id}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-config" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.terraform_state]

  bucket = aws_s3_bucket.terraform_state.id
  rule {
    id = "config"

    filter {
      prefix = "config/"
    }
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }
    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
    status = "Enabled"
  }
}


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
