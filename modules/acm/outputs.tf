output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = data.aws_acm_certificate.main.arn
}

output "certificate_domain_name" {
  description = "Domain name for the certificate"
  value       = data.aws_acm_certificate.main.domain
}

output "certificate_status" {
  description = "Certificate status"
  value       = data.aws_acm_certificate.main.status
}
