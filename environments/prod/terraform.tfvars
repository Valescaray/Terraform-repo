environment = "prod"

# VPC Configuration
vpc_cidr           = "10.1.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
single_nat_gateway = false  # High availability for prod

# EKS Configuration
eks_cluster_version    = "1.28"
eks_node_instance_types = ["t3.large"]
eks_node_desired_size   = 3
eks_node_min_size       = 2
eks_node_max_size       = 6

# ArgoCD
argocd_enabled = true
gitops_repo_url = "https://github.com/Valescaray/gitops-repo"

# Secrets
create_secrets = true

# S3
enable_s3_versioning = true

# Tags
tags = {
  Environment = "prod"
  ManagedBy   = "Terraform"
  Project     = "invoice-analyzer"
  CostCenter  = "production"
}
