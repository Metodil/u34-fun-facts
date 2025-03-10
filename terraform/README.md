## Terraform code for infrastructure in AWS

### Common infrastructure
> - create s3 for save states
> - create lock table
> - primary VPC
#### [More here in aws_common/README](aws_common/README.md)
### EKS cluster infrastructure
> - create Eks cluster with all needed sub structure
#### [More here in aws_eks/README](aws_eks/README.md)
### Argocd and Observability infrastructure
> - create Argocd whith Helm in EKS cluster
> - create Prometeus and Grafana whith Helm in EKS cluster
#### [More here in aws_eks_add_ons/README](aws_eks_add_ons/README.md)
### Set external secrets in EKS from Hashi Vault infrastructure
> - create External secrets in EKS Cluster from Hashi Vault infrastructure
#### [More here in aws_eks_ext_secrets/README](aws_eks_ext_secrets/README.md)
### Hashi Vault infrastructure
> - create EC2 instance with AMI created from Packer
> - auto unseal Vault with KMS
> - dynamoDB backend
> - Let's Encript for Vault
> - Route53 records
#### [More here in aws_vault/README](aws_vault/README.md)
