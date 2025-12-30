# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

# EKS Outputs
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS cluster Kubernetes version"
  value       = module.eks.cluster_version
}

output "eks_oidc_provider" {
  description = "EKS OIDC provider URL"
  value       = module.eks.oidc_provider
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

# IAM Outputs
output "backend_role_arn" {
  description = "Backend service account IAM role ARN"
  value       = module.iam.backend_role_arn
}

output "external_secrets_role_arn" {
  description = "External Secrets Operator IAM role ARN"
  value       = module.iam.external_secrets_role_arn
}

output "alb_controller_role_arn" {
  description = "ALB Controller IAM role ARN"
  value       = module.iam.alb_controller_role_arn
}

output "ebs_csi_role_arn" {
  description = "EBS CSI Driver IAM role ARN"
  value       = module.iam.ebs_csi_role_arn
}

# Route53 Outputs
output "route53_zone_id" {
  description = "Route53 hosted zone ID"
  value       = module.route53.zone_id
}

output "route53_name_servers" {
  description = "Route53 name servers"
  value       = module.route53.name_servers
}

# ACM Outputs
output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = module.acm.certificate_arn
}

# S3 Outputs
output "s3_upload_bucket_name" {
  description = "S3 upload bucket name"
  value       = module.s3.upload_bucket_name
}

output "s3_upload_bucket_arn" {
  description = "S3 upload bucket ARN"
  value       = module.s3.upload_bucket_arn
}

# Secrets Manager Outputs
output "secrets_manager_backend_secret_arn" {
  description = "Backend secrets ARN"
  value       = module.secrets_manager.backend_secret_arn
}

output "secrets_manager_database_secret_arn" {
  description = "Database secrets ARN"
  value       = module.secrets_manager.database_secret_arn
}

output "secrets_manager_grafana_secret_arn" {
  description = "Grafana secrets ARN"
  value       = module.secrets_manager.grafana_secret_arn
}

# ArgoCD Outputs
output "argocd_server_url" {
  description = "ArgoCD server URL"
  value       = var.argocd_enabled ? "https://argocd.${var.domain_name}" : "ArgoCD not enabled"
}
