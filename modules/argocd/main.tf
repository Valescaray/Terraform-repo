locals {
  argocd_namespace = "argocd"
  argocd_hostname  = "argocd.${var.domain_name}"
}

# ArgoCD Namespace
resource "kubernetes_namespace" "argocd" {
  count = var.enabled ? 1 : 0

  metadata {
    name = local.argocd_namespace
  }
}




# ArgoCD Helm Release
resource "helm_release" "argocd" {
  count = var.enabled ? 1 : 0

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = local.argocd_namespace
  version = "5.51.0"

  timeout = 600
  wait    = true
  atomic  = true

  values = [
    yamlencode({
      global = {
        domain = local.argocd_hostname
      }

      configs = {
        params = {
          "server.insecure" = true
        }
      }

      server = {
        ingress = {
          enabled = true
          annotations = {
            "kubernetes.io/ingress.class"                    = "alb"
            "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
            "alb.ingress.kubernetes.io/target-type"          = "ip"
            "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
            "alb.ingress.kubernetes.io/ssl-redirect"         = "443"
            "alb.ingress.kubernetes.io/backend-protocol"     = "HTTP"
          }
          hosts = [local.argocd_hostname]
          tls = [{
            hosts = [local.argocd_hostname]
          }]
        }

        extraArgs = [
          "--insecure"
        ]
      }

      repoServer = {
        replicas = 1
      }

      applicationSet = {
        enabled = true
      }

      notifications = {
        enabled = false
      }
    })
  ]

  depends_on = [kubernetes_namespace.argocd]
}

# Bootstrap Application - Created separately to avoid CRD timing issues
resource "kubernetes_manifest" "bootstrap_application" {
  count = var.enabled ? 1 : 0

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "bootstrap"
      namespace = local.argocd_namespace
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.gitops_repo_url
        targetRevision = var.gitops_repo_revision
        path           = var.gitops_repo_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = local.argocd_namespace
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }

  # Wait for CRDs to be installed by ArgoCD
  wait {
    fields = {
      "status.health.status" = "Healthy"
    }
  }

  # Allow Terraform to manage this even if CRDs don't exist during plan
  computed_fields = ["status"]

  depends_on = [helm_release.argocd]
}

