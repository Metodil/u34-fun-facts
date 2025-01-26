data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    bucket = "${var.bucket_name}"
    key    = "${var.aws_s3_state_common_name}"
    region = "${var.aws_region}"
  }
}

locals {
  common_out  = data.terraform_remote_state.common.outputs
  environment = terraform.workspace
  #############################################
  environments = {
    default = {
      env = "default"
      # EKS variables
      eks_managed_node_groups = {
        generalworkload-v4 = {
          min_size       = 2
          max_size       = 3
          desired_size   = 2
          instance_types = ["t3.midium"] #m5a.xlarge
          disk_size      = 30
          ebs_optimized  = true
          iam_role_additional_policies = {
            ssm_access        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
            cloudwatch_access = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
            service_role_ssm  = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
            default_policy    = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
          }
        }
      }
      cluster_security_group_additional_rules = {}
      eks_access_entries = {
        viewer = {
          user_arn = []
        }
        admin = {
          user_arn = ["arn:aws:iam::482167452852:root", "arn:aws:iam::482167452852:user/meto-su"]
        }
      }
      # EKS Addons variables
      coredns_config = {
        replicaCount = 1
      }
    }

  }

  #############################################
  k8s_info = lookup(local.environments, local.environment)

  eks_access_entries = flatten([for k, v in local.k8s_info.eks_access_entries : [for s in v.user_arn : { username = s, access_policy = lookup(local.eks_access_policy, k), group = k }]])

  eks_access_policy = {
    viewer = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy",
    admin  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  }
  project = "u34k8s"
  #  account_id = data.aws_caller_identity.current.account_id
  default_tags = {
    environment = local.environment
    managed_by  = "terraform"
    project     = local.project
  }
}
