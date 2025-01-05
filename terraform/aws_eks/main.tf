
module "dev_cluster" {
  source             = "./cluster"
  cluster_name       = "u34-dev"
  instance_type      = "t2.micro"
  default_tags       = local.default_tags
  eks_access_entries = local.eks_access_entries
}

#module "staging_cluster" {
#  source        = "./cluster"
#  cluster_name  = "staging"
#  instance_type = "t2.micro"
#}
#
#module "production_cluster" {
#  source        = "./cluster"
#  cluster_name  = "production"
#  instance_type = "m5.large"
#}
