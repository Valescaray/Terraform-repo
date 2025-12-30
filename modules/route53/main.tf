# Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  count = var.create_zone ? 1 : 0
  name  = var.domain_name

  tags = {
    Name        = var.domain_name
    Environment = var.environment
  }
}

data "aws_route53_zone" "main" {
  count = var.create_zone ? 0 : 1
  name  = var.domain_name
}
