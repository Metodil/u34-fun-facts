<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.80.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dev_cluster"></a> [dev\_cluster](#module\_dev\_cluster) | ./cluster | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.common](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_db_lock_state_name"></a> [aws\_db\_lock\_state\_name](#input\_aws\_db\_lock\_state\_name) | value of the dynamodb table lock name | `string` | `"u34-lock"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | value of the region where the resources will be created | `string` | `"eu-central-1"` | no |
| <a name="input_aws_s3_state_common_name"></a> [aws\_s3\_state\_common\_name](#input\_aws\_s3\_state\_common\_name) | value of the s3 state name | `string` | `"common.tfstate"` | no |
| <a name="input_aws_s3_state_eks_name"></a> [aws\_s3\_state\_eks\_name](#input\_aws\_s3\_state\_eks\_name) | value of the s3 state name | `string` | `"eks.tfstate"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The bucket to use for storing terrform state files | `string` | `"u34-tfstate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dev_cluster_output"></a> [dev\_cluster\_output](#output\_dev\_cluster\_output) | The output of the created dev cluster. |
<!-- END_TF_DOCS -->
