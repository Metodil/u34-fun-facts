# This is the bucket where anything required by the userdata will be uploaded to.
# The userdata will then pull these objects down as required.
resource "aws_s3_bucket" "vault_config_bucket" {
  bucket = var.bucket_vault_name

  tags = {
    Name = var.bucket_vault_name
  }
}

# Upload the vault admin policy to S3
resource "aws_s3_object" "vault_admin_policy" {
  bucket = aws_s3_bucket.vault_config_bucket.id
  key    = "vault-admin-policy.hcl"
  source = "templates/vault-admin-policy.hcl"
}
