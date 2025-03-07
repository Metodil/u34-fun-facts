## EKS Add ons :  ARGOCD + PROMETHEUS
### terraform/aws_eks_add_ons list of files:
> -  *main.tf*
>    - installing ARGOCD with Help chart
>    - installing PROMETHEUS + GRAFANA  with Help chart
> -  *argocd_fun_facts-app*
>    - Fun facts application manifest for ARGOCD to deploy in EKS "u34-dev" cluster
> -  *output.tf*
> -  *provider.tf*
> -  *variables.tf*
> -  *version.tf*
>    - AWS backend for tfstate and locks


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.80.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.80.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_db_lock_state_name"></a> [aws\_db\_lock\_state\_name](#input\_aws\_db\_lock\_state\_name) | value of the dynamodb table lock name | `string` | `"u34-lock"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | value of the region where the resources will be created | `string` | `"eu-central-1"` | no |
| <a name="input_aws_s3_state_eks_add_ons_name"></a> [aws\_s3\_state\_eks\_add\_ons\_name](#input\_aws\_s3\_state\_eks\_add\_ons\_name) | value of the s3 state name | `string` | `"eks_add_ons.tfstate"` | no |
| <a name="input_aws_s3_state_eks_name"></a> [aws\_s3\_state\_eks\_name](#input\_aws\_s3\_state\_eks\_name) | value of the s3 state name | `string` | `"eks.tfstate"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The bucket to use for storing terrform state files | `string` | `"u34-tfstate"` | no |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name | `string` | `"dev"` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | The environment configuration | `any` | `"dev"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | n/a | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
