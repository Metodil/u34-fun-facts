resource "aws_secretsmanager_secret" "vault-root-token" {
  name        = var.vault-root-token
  description = "Vault root token"
  # recovery set to 0 so we can recreate the secret as required for testing.
  recovery_window_in_days = 0
  tags = {
    Name = var.vault-root-token
  }
}

resource "aws_secretsmanager_secret" "vault-unseal-key" {
  name        = var.vault-unseal-key
  description = "Vault unseal key"
  # recovery set to 0 so we can recreate the secret as required for testing.
  recovery_window_in_days = 0
  tags = {
    Name = var.vault-unseal-key
  }
}
