output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The id of the created vpc."
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "The public_subnets of the created vpc."
}
