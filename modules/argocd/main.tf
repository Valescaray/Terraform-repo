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
          "server.insecure" = false
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
            "alb.ingress.kubernetes.io/backend-protocol"     = "HTTPS"
            "alb.ingress.kubernetes.io/certificate-arn"      = var.acm_certificate_arn
          }
          hosts = [local.argocd_hostname]
          tls = [{
            hosts = [local.argocd_hostname]
          }]
        }

        extraArgs = []
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
# Using null_resource with kubectl to avoid plan-time CRD validation
resource "null_resource" "bootstrap_application" {
  count = var.enabled ? 1 : 0

  triggers = {
    gitops_repo_url      = var.gitops_repo_url
    gitops_repo_revision = var.gitops_repo_revision
    gitops_repo_path     = var.gitops_repo_path
    argocd_namespace     = local.argocd_namespace
    aws_region           = var.aws_region
    eks_cluster_name     = var.eks_cluster_name
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --region ${var.aws_region} --name ${var.eks_cluster_name}
      cat <<EOF | kubectl apply -f -
      apiVersion: argoproj.io/v1alpha1
      kind: Application
      metadata:
        name: bootstrap
        namespace: ${local.argocd_namespace}
      spec:
        project: default
        source:
          repoURL: ${var.gitops_repo_url}
          targetRevision: ${var.gitops_repo_revision}
          path: ${var.gitops_repo_path}
        destination:
          server: https://kubernetes.default.svc
          namespace: ${local.argocd_namespace}
        syncPolicy:
          automated:
            prune: true
            selfHeal: true
      EOF
    EOT
    
    environment = {
      AWS_REGION = var.aws_region
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      aws eks update-kubeconfig --region ${self.triggers.aws_region} --name ${self.triggers.eks_cluster_name}
      kubectl delete application bootstrap -n ${self.triggers.argocd_namespace} --ignore-not-found=true
    EOT
  }

  depends_on = [helm_release.argocd]
}

