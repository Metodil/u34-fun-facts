data "template_file" "userdata" {
  template = file("${path.module}/templates/vault.sh.tpl")

  vars = {
    region               = var.aws_region
    vault_dynamodb-table = var.dynamodb_table
    unseal-key           = aws_kms_key.vault-unseal-key.id
    vault_kms_key        = aws_kms_alias.vault-kms-alias.arn
    instance-role        = aws_iam_role.vault-kms-unseal.name
    vault_instance_role  = "arn:aws:iam:${var.aws_region}:${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.vault-kms-unseal.name}"
    vault_bucket         = var.bucket_vault_name
    secret_token_id      = aws_secretsmanager_secret.vault-root-token.id
    secret_unseal_id     = aws_secretsmanager_secret.vault-unseal-key.id
    vault_fqdn           = var.vault_fqdn
    letsencript-mail     = var.letsencrypt_mail
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_subnet_name]
  }
}

# Get id from my packer created Immutable Ubuntu AMI
data "aws_ami" "ubuntu" {
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_instance_name]
  }
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_route53_zone" "selected" {
  name         = "u34-vault.link"
  private_zone = false
}
