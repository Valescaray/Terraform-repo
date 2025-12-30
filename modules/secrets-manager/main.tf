locals {
  name = var.project_name
}

# Backend Secrets
resource "aws_secretsmanager_secret" "backend" {
  count = var.create_secrets ? 1 : 0

  name        = "${local.name}/backend"
  description = "Backend application secrets"

  tags = {
    Name        = "${local.name}/backend"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "backend" {
  count = var.create_secrets ? 1 : 0

  secret_id = aws_secretsmanager_secret.backend[0].id
  secret_string = jsonencode({
    database-url           = "postgresql://user:password@postgres-service:5432/invoice_analyzer"
    aws-access-key-id      = "PLACEHOLDER_UPDATE_ME"
    aws-secret-access-key  = "PLACEHOLDER_UPDATE_ME"
    openai-api-key         = "PLACEHOLDER_UPDATE_ME"
    firebase-private-key   = "PLACEHOLDER_UPDATE_ME"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# Database Secrets
resource "aws_secretsmanager_secret" "database" {
  count = var.create_secrets ? 1 : 0

  name        = "${local.name}/database"
  description = "Database credentials"

  tags = {
    Name        = "${local.name}/database"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "database" {
  count = var.create_secrets ? 1 : 0

  secret_id = aws_secretsmanager_secret.database[0].id
  secret_string = jsonencode({
    username = "postgres"
    password = "PLACEHOLDER_UPDATE_ME"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# Grafana Secrets
resource "aws_secretsmanager_secret" "grafana" {
  count = var.create_secrets ? 1 : 0

  name        = "${local.name}/grafana"
  description = "Grafana admin credentials"

  tags = {
    Name        = "${local.name}/grafana"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "grafana" {
  count = var.create_secrets ? 1 : 0

  secret_id = aws_secretsmanager_secret.grafana[0].id
  secret_string = jsonencode({
    admin-user     = "admin"
    admin-password = "PLACEHOLDER_UPDATE_ME"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}
