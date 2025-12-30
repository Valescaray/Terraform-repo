# Deployment Guide

This guide details the steps to deploy the infrastructure and connect it with the GitOps repository.

## Pre-Deployment Steps

1. **DNS Configuration**
   - Typically, you need to register `oppsdev.xyz`
   - After the `route53` module runs, it will output nameservers. Update your registrar with these NS records.

2. **Terraform State Backend**
   - Create the S3 bucket manually if it doesn't exist: `invoice-analyzer-terraform-state` (Region: us-west-2)
   - Create DynamoDB table: `invoice-analyzer-terraform-locks` (Partition key: `LockID`)

## Deployment Sequence

### 1. Networking & Cluster (Dev)
Deploy the core infrastructure first.

```bash
terraform init
terraform apply -target=module.vpc -target=module.eks -var-file=environments/dev/terraform.tfvars
```

### 2. Supporting Services
Once EKS is up, deploy the rest. The ALB controller and ArgoCD rely on the cluster being ready.

```bash
terraform apply -var-file=environments/dev/terraform.tfvars
```

## Post-Deployment Configuration

### 1. Update GitOps Repo
After Terraform finishes, gather the following outputs:
- `eks_cluster_name`
- `acm_certificate_arn`
- `backend_role_arn`
- `external_secrets_role_arn`

Update your `gitops-repo/environments/dev` files with these ARNs.

### 2. Secrets Manager
The Terraform `secrets-manager` module creates secrets with placeholder values. Go to the AWS Console -> Secrets Manager and update:
- `invoice-analyzer/dev/backend`: Database URL, Keys
- `invoice-analyzer/dev/database`: Real DB password
- `invoice-analyzer/dev/grafana`: Admin password

### 3. Connect ArgoCD
1. Get the initial admin password:
   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   ```
2. Login to `https://argocd.oppsdev.xyz`
3. Connect your GitOps repository

## Troubleshooting

- **ALB Ingress not created**: Check logs of `aws-load-balancer-controller` in `kube-system` namespace.
- **Certificate validation stuck**: Ensure your NS records at the registrar match the `name_servers` output from Terraform.
