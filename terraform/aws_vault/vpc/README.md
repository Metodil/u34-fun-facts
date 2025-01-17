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
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.16.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | default value of eks cluster | `string` | `"k8s-eks"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | default value of vpc | `string` | `"k8s-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | The public\_subnets of the created vpc. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The id of the created vpc. |
<!-- END_TF_DOCS -->
