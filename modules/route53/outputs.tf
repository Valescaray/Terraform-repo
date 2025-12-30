output "zone_id" {
  description = "Route53 hosted zone ID"
  value       = var.create_zone ? aws_route53_zone.main[0].zone_id : data.aws_route53_zone.main[0].zone_id
}

output "name_servers" {
  description = "Route53 name servers"
  value       = var.create_zone ? aws_route53_zone.main[0].name_servers : data.aws_route53_zone.main[0].name_servers
}

output "zone_arn" {
  description = "Route53 hosted zone ARN"
  value       = var.create_zone ? aws_route53_zone.main[0].arn : data.aws_route53_zone.main[0].arn
}
