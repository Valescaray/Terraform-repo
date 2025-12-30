locals {
  name = "${var.project_name}-${var.environment}"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Backend Service Account IAM Role (S3 Access)
resource "aws_iam_role" "backend" {
  name = "${local.name}-backend-sa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = var.eks_oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${var.eks_oidc_provider}:sub" = "system:serviceaccount:${local.name}:backend-sa"
          "${var.eks_oidc_provider}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })

  tags = {
    Name = "${local.name}-backend-sa-role"
  }
}

resource "aws_iam_policy" "backend_s3" {
  name        = "${local.name}-backend-s3-policy"
  description = "Policy for backend to access S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${local.name}-uploads",
          "arn:aws:s3:::${local.name}-uploads/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backend_s3" {
  policy_arn = aws_iam_policy.backend_s3.arn
  role       = aws_iam_role.backend.name
}

# External Secrets Operator IAM Role
resource "aws_iam_role" "external_secrets" {
  name = "${local.name}-external-secrets-sa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = var.eks_oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${var.eks_oidc_provider}:sub" = "system:serviceaccount:${local.name}:external-secrets-sa"
          "${var.eks_oidc_provider}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })

  tags = {
    Name = "${local.name}-external-secrets-sa-role"
  }
}

resource "aws_iam_policy" "external_secrets" {
  name        = "${local.name}-external-secrets-policy"
  description = "Policy for External Secrets Operator to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ]
        Resource = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.project_name}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_secrets" {
  policy_arn = aws_iam_policy.external_secrets.arn
  role       = aws_iam_role.external_secrets.name
}

# AWS Load Balancer Controller IAM Role
resource "aws_iam_role" "alb_controller" {
  name = "${local.name}-alb-controller-sa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = var.eks_oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${var.eks_oidc_provider}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          "${var.eks_oidc_provider}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })

  tags = {
    Name = "${local.name}-alb-controller-sa-role"
  }
}

# AWS Load Balancer Controller Policy
resource "aws_iam_policy" "alb_controller" {
  name        = "${local.name}-alb-controller-policy"
  description = "Policy for AWS Load Balancer Controller"

  policy = file("${path.module}/alb-controller-policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  policy_arn = aws_iam_policy.alb_controller.arn
  role       = aws_iam_role.alb_controller.name
}
