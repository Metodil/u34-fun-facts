#outputs.tf
output "module_vpc_output" {
  value       = module.vault-vpc
  description = "The output of the created vault vpc."
}

output "public_url" {
  description = "Public IRL for our Vault Server"
  value       = "http://${aws_instance.vault.public_ip}:8200"
}


output "private_ip" {
  description = "Vault private IP Address:"
  value       = aws_instance.vault.private_ip
}

output "public_ip" {
  description = "Vault public IP Address:"
  value       = aws_instance.vault.public_ip
}
