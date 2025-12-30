output "helm_release_name" {
  description = "Helm release name for AWS Load Balancer Controller"
  value       = helm_release.aws_load_balancer_controller.name
}

output "helm_release_status" {
  description = "Helm release status"
  value       = helm_release.aws_load_balancer_controller.status
}
