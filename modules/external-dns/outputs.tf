output "helm_release_name" {
  description = "Helm release name for ExternalDNS"
  value       = helm_release.external_dns.name
}

output "iam_role_arn" {
  description = "IAM Role ARN for ExternalDNS"
  value       = module.external_dns_irsa_role.iam_role_arn
}
