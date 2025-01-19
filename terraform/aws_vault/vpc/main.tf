data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name = "${var.vpc_name}-vpc"
  cidr = "10.0.0.0/16"

  azs                     = data.aws_availability_zones.available.names
  private_subnets         = ["10.0.1.0/24"]
  public_subnets          = ["10.0.101.0/24"]
  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.vpc_name}-vpc"
    Environment = "dev"
  }
}

#  cidr                    = "172.16.0.0/16"
#  private_subnets         = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
#  public_subnets          = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
