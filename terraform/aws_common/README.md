## Creating common infrastructure in AWS
### terraform/aws_common list of files:
> -  *aws-ddb.tf*
>    - dynamodb_table for locking
> -  *aws-s3-bucket.tf*
>    - s3 bucket for keeping state
> -  *provider.tf*
> -  *vpc.tf*
>    - AWS VPC for using in all infrastructure
> -  *variables.tf*
> -  *version.tf*
>    - AWS backend for tfstate


<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.80.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.terraform_state_lock](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.versioning-bucket-config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.encrypting_bicket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_db_lock_state_name"></a> [aws\_db\_lock\_state\_name](#input\_aws\_db\_lock\_state\_name) | value of the dynamodb table lock name | `string` | `"u34-lock"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | value of the region where the resources will be created | `string` | `"eu-central-1"` | no |
| <a name="input_aws_s3_state_common_name"></a> [aws\_s3\_state\_common\_name](#input\_aws\_s3\_state\_common\_name) | value of the s3 state name | `string` | `"common.tfstate"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The bucket to use for storing terrform state files | `string` | `"u34-tfstate"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | default value of eks cluster | `string` | `"k8s-eks"` | no |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name | `string` | `"dev"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | n/a | `bool` | `false` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | default value of vpc | `string` | `"k8s-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_s3_bucket"></a> [aws\_s3\_bucket](#output\_aws\_s3\_bucket) | n/a |
<!-- END_TF_DOCS -->
