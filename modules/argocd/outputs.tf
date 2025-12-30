output "namespace" {
  description = "ArgoCD namespace"
  value       = var.enabled ? local.argocd_namespace : ""
}

output "hostname" {
  description = "ArgoCD hostname"
  value       = var.enabled ? local.argocd_hostname : ""
}

output "helm_release_name" {
  description = "Helm release name"
  value       = var.enabled ? helm_release.argocd[0].name : ""
}

output "helm_release_status" {
  description = "Helm release status"
  value       = var.enabled ? helm_release.argocd[0].status : ""
}
