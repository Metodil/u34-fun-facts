data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "template_file" "userdata" {
  template = file("${path.module}/templates/vault.sh.tpl")

  vars = {
    region              = var.aws_region
    dynamodb-table      = var.dynamodb_table
    unseal-key          = aws_kms_key.vault-unseal-key.id
    instance-role       = aws_iam_role.vault-kms-unseal.name
    vault_instance_role = "arn:aws:iam:${var.aws_region}:${locals.account_id}:role/${aws_iam_role.vault-kms.name}"
    vault_bucket        = var.bucket_name
    secret_token_id     = aws_secretsmanager_secret.vault-root-token.id
    secret_unseal_id    = aws_secretsmanager_secret.vault-unseal-key.id
  }
}
