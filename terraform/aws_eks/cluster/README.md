<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 20.31.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.16.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.worker_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | value of the region where the resources will be created | `any` | `"eu-central-1"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | the name of the cluster | `string` | `"u34-k8s"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `string` | `"u34_fp"` | no |
| <a name="input_eks_access_entries"></a> [eks\_access\_entries](#input\_eks\_access\_entries) | n/a | `any` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | default instance type | `string` | `"t3.large"` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | n/a | `string` | `"public_subnets"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `"vpc_id"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | default value of vpc | `string` | `"k8s-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_entries"></a> [access\_entries](#output\_access\_entries) | n/a |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | The certificate data required to communicate with the EKS cluster. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint for the EKS Kubernetes API server. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the created EKS cluster. |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | The version of Kubernetes running on the EKS cluster. |
| <a name="output_oidc_provider"></a> [oidc\_provider](#output\_oidc\_provider) | n/a |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | n/a |
<!-- END_TF_DOCS -->
