variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_oidc_provider" {
  description = "EKS OIDC provider URL"
  type        = string
}

variable "eks_oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  type        = string
}
