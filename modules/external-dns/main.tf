locals {
  name = "external-dns"
}

# IAM Role for ExternalDNS
module "external_dns_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                     = "${local.name}-${var.environment}-role"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/*"] # Narrow down if possible, but * is standard for broad access

  oidc_providers = {
    ex = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}

# ExternalDNS Helm Release
resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = var.external_dns_version

  timeout         = 600
  wait            = true
  atomic          = false  # Allow debugging on failure instead of immediate rollback
  cleanup_on_fail = false  # Keep resources for troubleshooting
  max_history     = 3

  disable_openapi_validation = true

  values = [
    yamlencode({
      serviceAccount = {
        create = true
        name   = "external-dns"
        annotations = {
          "eks.amazonaws.com/role-arn" = module.external_dns_irsa_role.iam_role_arn
        }
      }
      provider      = "aws"
      policy        = "upsert-only"
      sources       = ["ingress", "service"]
      domainFilters = [var.domain_name]

      logLevel  = "debug"
      logFormat = "json"

      image = {
        registry   = "registry.k8s.io"
        repository = "external-dns/external-dns"
        tag        = "v0.14.2"
        pullPolicy = "IfNotPresent"
      }
    })
  ]
}

