locals {
  name = "${var.project_name}-${var.environment}"
}

# AWS Load Balancer Controller Helm Chart
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.6.2"

  values = [
    yamlencode({
      clusterName = var.eks_cluster_name
      region      = data.aws_region.current.name
      vpcId       = var.vpc_id
      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
        annotations = {
          "eks.amazonaws.com/role-arn" = var.alb_controller_role_arn
        }
      }
      defaultTags = {
        Environment = var.environment
        Application = var.project_name
      }
    })
  ]
}

data "aws_region" "current" {}
