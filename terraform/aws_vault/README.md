## EC2 Instance with Hashi Vault for security management
### terraform/aws_vault list of files:
> -  *data.tf*
>    - populate data in template/vault.sh.tpl
> -  *dynamodb.tf*
>    - create dynamodb for storage
> -  *kms.tf*
>    - kms key that vault uses to unseal itself
> -  *main.tf*
>    - create aws instance vault
>    - generate tls_private_key for access in instance
>    - create security groups
> -  *output.tf*
> -  *provider.tf*
> -  *route53.tf*
>    - add aws route53 record for vault with instance IP
> -  *s3.tf*
>    - for storing configuration
> -  *secrets-manager.tf*
>    - create secret vault-root-token
>    - create secret vault-unseal-key
> -  *vault-policy.tf*
>    - policy for access to AWS resources
> -  *variables.tf*
> -  *version.tf*
>    - AWS backend for tfstate and locks
> -  *folder->templates*
>    - *vault-admin-policy.hcl*
>      - give this instance admin privileges to vault
>    - *vault.sh.tpl*
>      - bash script for configure Vault in desired state
>        - set new vault config file
>        - initialise vault and save root token and unseal key in AWS secrets manager
>        - enable the vault AWS and kv engine
>        - create vault certificate with certbot and implementation in VAULT
>        - restart vault with new configuration

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.80.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.87.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.2 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.vault-table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_instance_profile.vault-kms-unseal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.vault-kms-unseal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.vault-kms-unseal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_instance.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.generated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_kms_alias.vault-kms-alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.vault-unseal-key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_route53_record.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.vault_config_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_object.vault_admin_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_secretsmanager_secret.vault-root-token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.vault-unseal-key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_security_group.ingress-ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpc-vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [local_file.private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.generated](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vault-kms-unseal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_file.userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_instance_name"></a> [ami\_instance\_name](#input\_ami\_instance\_name) | AWS Instance Vault Name | `string` | `"u34-vault-ami"` | no |
| <a name="input_aws_db_lock_state_name"></a> [aws\_db\_lock\_state\_name](#input\_aws\_db\_lock\_state\_name) | value of the dynamodb table lock name | `string` | `"u34-lock"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | value of the region where the resources will be created | `string` | `"eu-central-1"` | no |
| <a name="input_aws_s3_state_common_name"></a> [aws\_s3\_state\_common\_name](#input\_aws\_s3\_state\_common\_name) | value of the s3 state name | `string` | `"common.tfstate"` | no |
| <a name="input_aws_s3_state_eks_name"></a> [aws\_s3\_state\_eks\_name](#input\_aws\_s3\_state\_eks\_name) | value of the s3 state name | `string` | `"eks.tfstate"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The bucket to use for storing terrform state files | `string` | `"u34-tfstate"` | no |
| <a name="input_bucket_vault_name"></a> [bucket\_vault\_name](#input\_bucket\_vault\_name) | Bucket to upload any required files | `string` | `"u34-vault-conf-bucket"` | no |
| <a name="input_dynamo-read-write"></a> [dynamo-read-write](#input\_dynamo-read-write) | Read / Write value | `number` | `1` | no |
| <a name="input_dynamodb_table"></a> [dynamodb\_table](#input\_dynamodb\_table) | AWS Dynamodb Table Name for Vault | `string` | `"u34-vault-dynamodb-table"` | no |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name | `string` | `"dev"` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | The environment configuration | `any` | `"dev"` | no |
| <a name="input_instance-profile"></a> [instance-profile](#input\_instance-profile) | The profile | `string` | `"vault-instance-profile"` | no |
| <a name="input_instance-role"></a> [instance-role](#input\_instance-role) | The instance role | `string` | `"vault-role"` | no |
| <a name="input_instance-role-policy"></a> [instance-role-policy](#input\_instance-role-policy) | The policy | `string` | `"vault-role-policy"` | no |
| <a name="input_instance_key_name"></a> [instance\_key\_name](#input\_instance\_key\_name) | AWS Instance Key Name | `string` | `"vault-aws-key"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | AWS Instance Type (EC2 Type) | `string` | `"t2.micro"` | no |
| <a name="input_letsencrypt_mail"></a> [letsencrypt\_mail](#input\_letsencrypt\_mail) | Email for letsencrypt | `string` | `"metodil@hotmail.com"` | no |
| <a name="input_new_instance_name"></a> [new\_instance\_name](#input\_new\_instance\_name) | New Instance Vault Name | `string` | `"u34-vault-instance"` | no |
| <a name="input_vault-root-token"></a> [vault-root-token](#input\_vault-root-token) | Name of the secrets manager secret to save the vault root token to | `string` | `"vault-root-token"` | no |
| <a name="input_vault-unseal-key"></a> [vault-unseal-key](#input\_vault-unseal-key) | Name of the secrets manager secret to save the vault unseal key to | `string` | `"vault-unseal-key"` | no |
| <a name="input_vault_fqdn"></a> [vault\_fqdn](#input\_vault\_fqdn) | FQDN of vault instace for tls | `string` | `"vault.u34-vault.link"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | default value of vpc | `string` | `"k8s-vpc"` | no |
| <a name="input_vpc_subnet_name"></a> [vpc\_subnet\_name](#input\_vpc\_subnet\_name) | default value of vpc subnet name | `string` | `"k8s-vpc-public-eu-central-1c"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Vault private IP Address: |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Vault public IP Address: |
| <a name="output_public_url"></a> [public\_url](#output\_public\_url) | Public IRL for our Vault Server |
| <a name="output_vault_server"></a> [vault\_server](#output\_vault\_server) | Vault Server |
<!-- END_TF_DOCS -->
