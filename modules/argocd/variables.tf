variable "enabled" {
  description = "Enable ArgoCD installation"
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "5.51.0"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for ArgoCD"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "gitops_repo_url" {
  description = "URL of the GitOps repository"
  type        = string
}

variable "gitops_repo_revision" {
  description = "Revision of the GitOps repository to track"
  type        = string
  default     = "HEAD"
}

variable "gitops_repo_path" {
  description = "Path within the GitOps repository to look for applications"
  type        = string
  default     = "argocd/applications"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for SSL/TLS"
  type        = string
}
