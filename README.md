# Invoice Analyzer Terraform Repository

This repository contains the Terraform configuration for provisioning the AWS infrastructure required for the Invoice Analyzer GitOps deployment.

## Architecture Overview

The infrastructure creates the following resources:
- **VPC**: Custom VPC with public/private subnets, NAT Gateways, and VPC Endpoints
- **EKS Cluster**: Managed Kubernetes cluster with node groups and OIDC
- **Networking**: ArgoCD ingress, ALB Controller, and Route53 DNS
- **Security**: IAM Roles for Service Accounts (IRSA), Security Groups, and NACLs
- **Storage**: S3 buckets for file uploads
- **Secrets**: AWS Secrets Manager for application secrets
- **CD**: ArgoCD for GitOps deployment

## Prerequisites

1. AWS Account and Credentials
2. Terraform >= 1.5.0
3. AWS CLI configured
4. Domain name (`oppsdev.xyz`) configured in Route53 (registrar pointing to AWS NS)

## Quick Start

### 1. Initialize Backend
Ensure the S3 bucket and DynamoDB table for Terraform state exist:
- Bucket: `invoice-analyzer-terraform-state`
- DynamoDB: `invoice-analyzer-terraform-locks`

### 2. Deploy Development Environment
```bash
terraform init -backend-config="key=dev/terraform.tfstate"
terraform plan -var-file=environments/dev/terraform.tfvars -out=dev.plan
terraform apply dev.plan
```

### 3. Deploy Production Environment
```bash
terraform init -backend-config="key=prod/terraform.tfstate"
terraform plan -var-file=environments/prod/terraform.tfvars -out=prod.plan
terraform apply prod.plan
```

### 4. Configure kubectl
After deployment, configure your local kubectl:
```bash
aws eks update-kubeconfig --region us-west-2 --name invoice-analyzer-dev-eks
```

## Folder Structure

- `environments/`: Environment-specific configurations (.tfvars)
- `modules/`: Reusable Terraform modules
  - `vpc`: Networking foundation
  - `eks`: Kubernetes cluster and nodes
  - `alb`: Application Load Balancer Controller
  - `iam`: IAM Roles and Policies
  - `route53`: DNS management
- `docs/`: Detailed documentation

## CI/CD

This repository uses GitHub Actions for CI/CD:
- `Terraform Plan`: Runs on Pull Request to main
- `Terraform Apply`: Runs on merge to main or via manual dispatch

## Outputs

Key outputs to note after deployment:
- `eks_cluster_endpoint`: API endpoint for the cluster
- `argocd_server_url`: URL for ArgoCD UI
- `name_servers`: Route53 name servers (update these at your registrar)
- `upload_bucket_name`: Name of the created S3 bucket
