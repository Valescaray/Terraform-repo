output "backend_secret_arn" {
  description = "Backend secret ARN"
  value       = var.create_secrets ? aws_secretsmanager_secret.backend[0].arn : ""
}

output "backend_secret_name" {
  description = "Backend secret name"
  value       = var.create_secrets ? aws_secretsmanager_secret.backend[0].name : ""
}

output "database_secret_arn" {
  description = "Database secret ARN"
  value       = var.create_secrets ? aws_secretsmanager_secret.database[0].arn : ""
}

output "database_secret_name" {
  description = "Database secret name"
  value       = var.create_secrets ? aws_secretsmanager_secret.database[0].name : ""
}

output "grafana_secret_arn" {
  description = "Grafana secret ARN"
  value       = var.create_secrets ? aws_secretsmanager_secret.grafana[0].arn : ""
}

output "grafana_secret_name" {
  description = "Grafana secret name"
  value       = var.create_secrets ? aws_secretsmanager_secret.grafana[0].name : ""
}
