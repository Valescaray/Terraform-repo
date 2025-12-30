output "backend_role_arn" {
  description = "Backend service account IAM role ARN"
  value       = aws_iam_role.backend.arn
}

output "backend_role_name" {
  description = "Backend service account IAM role name"
  value       = aws_iam_role.backend.name
}

output "external_secrets_role_arn" {
  description = "External Secrets Operator IAM role ARN"
  value       = aws_iam_role.external_secrets.arn
}

output "external_secrets_role_name" {
  description = "External Secrets Operator IAM role name"
  value       = aws_iam_role.external_secrets.name
}

output "alb_controller_role_arn" {
  description = "ALB Controller IAM role ARN"
  value       = aws_iam_role.alb_controller.arn
}

output "alb_controller_role_name" {
  description = "ALB Controller IAM role name"
  value       = aws_iam_role.alb_controller.name
}

output "ebs_csi_role_arn" {
  description = "EBS CSI Driver IAM role ARN (from EKS module)"
  value       = ""
}
