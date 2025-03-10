#module "eks-kubeconfig" {
#  source     = "hyperbadger/eks-kubeconfig/aws"
#  version    = "2.0.0"
#  cluster_name = module.eks.cluster_name
#  depends_on = [module.eks]
#}
#
#resource "local_file" "kubeconfig" {
#  content  = module.eks-kubeconfig.kubeconfig
#  filename = "kubeconfig_${var.cluster_name}"
#}

data "aws_availability_zones" "available" {}

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

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.0"

  cluster_name                    = var.cluster_name
  cluster_version                 = "1.31"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  subnet_ids                      = [data.aws_subnet.selected.id]
  vpc_id                          = data.aws_vpc.selected.id

  eks_managed_node_groups = {
    first = {
      desired_capacity = 2
      max_capacity     = 5
      min_capacity     = 2

      instance_type = "${var.instance_type}"
    }
  }

  access_entries = {
    for k in var.eks_access_entries : k.username => {
      kubernetes_groups = []
      principal_arn     = k.username
      policy_associations = {
        single = {
          policy_arn = k.access_policy
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  tags = var.default_tags


  #  node_security_group_additional_rules = {
  #    ingress_allow_access_from_control_plane = {
  #      type                          = "ingress"
  #      protocol                      = "tcp"
  #      from_port                     = 9443
  #      to_port                       = 9443
  #      source_cluster_security_group = true
  #      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
  #    }
  #  }
}

resource "aws_iam_policy" "worker_policy" {
  name        = "worker-policy-${var.cluster_name}"
  description = "Worker policy for the ALB Ingress"

  policy = file("iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = module.eks.eks_managed_node_groups

  policy_arn = aws_iam_policy.worker_policy.arn
  role       = each.value.iam_role_name
}
