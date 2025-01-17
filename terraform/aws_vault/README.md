<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.80.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.80.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vault-vpc"></a> [vault-vpc](#module\_vault-vpc) | ./vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_instance.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.generated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.ingress-ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpc-vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [local_file.private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.generated](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_db_lock_state_name"></a> [aws\_db\_lock\_state\_name](#input\_aws\_db\_lock\_state\_name) | value of the dynamodb table lock name | `string` | `"u34-lock"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | value of the region where the resources will be created | `string` | `"eu-central-1"` | no |
| <a name="input_aws_s3_state_common_name"></a> [aws\_s3\_state\_common\_name](#input\_aws\_s3\_state\_common\_name) | value of the s3 state name | `string` | `"common.tfstate"` | no |
| <a name="input_aws_s3_state_eks_name"></a> [aws\_s3\_state\_eks\_name](#input\_aws\_s3\_state\_eks\_name) | value of the s3 state name | `string` | `"eks.tfstate"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The bucket to use for storing terrform state files | `string` | `"u34-tfstate"` | no |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name | `string` | `"dev"` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | The environment configuration | `any` | `"dev"` | no |
| <a name="input_instance_key_name"></a> [instance\_key\_name](#input\_instance\_key\_name) | AWS Instance Key Name | `string` | `"vault-aws-key"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | AWS Instance Type (EC2 Type) | `string` | `"t2.micro"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_module_vpc_output"></a> [module\_vpc\_output](#output\_module\_vpc\_output) | The output of the created vault vpc. |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Vault private IP Address: |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Vault public IP Address: |
| <a name="output_public_url"></a> [public\_url](#output\_public\_url) | Public IRL for our Vault Server |
<!-- END_TF_DOCS -->
