data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "vault-kms-unseal" {
  statement {
    sid       = "VaultKMSUnseal"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
  }

  statement {
    sid       = "VaultDynamoDB"
    effect    = "Allow"
    resources = [aws_dynamodb_table.vault-table.arn]

    actions = [
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ]
  }

  statement {
    sid       = "IAM"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:GetInstanceProfile",
      "iam:GetRole",
      "iam:CreateUser",
      "iam:PutUserPolicy",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:GetAccessKeyLastUsed",
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey",
      "sts:AssumeRole"
    ]
  }

  statement {
    sid       = "S3"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.bucket_vault_name}/*"]

    actions = [
      "s3:GetObject"
    ]
  }

  statement {
    sid       = "SecretsManager"
    effect    = "Allow"
    resources = [aws_secretsmanager_secret.vault-root-token.id, aws_secretsmanager_secret.vault-unseal-key.id]


    actions = [
      "secretsmanager:UpdateSecret",
      "secretsmanager:GetSecretValue"
    ]
  }
}

resource "aws_iam_role" "vault-kms-unseal" {
  name               = var.instance-role
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "vault-kms-unseal" {
  name   = var.instance-role-policy
  role   = aws_iam_role.vault-kms-unseal.id
  policy = data.aws_iam_policy_document.vault-kms-unseal.json
}

resource "aws_iam_instance_profile" "vault-kms-unseal" {
  name = var.instance-profile
  role = aws_iam_role.vault-kms-unseal.name
}
