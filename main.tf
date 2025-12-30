provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "Terraform"
      },
      var.tags
    )
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  project_name         = var.project_name
  environment          = var.environment
  cluster_version      = var.eks_cluster_version
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  node_instance_types  = var.eks_node_instance_types
  node_desired_size    = var.eks_node_desired_size
  node_min_size        = var.eks_node_min_size
  node_max_size        = var.eks_node_max_size
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  project_name        = var.project_name
  environment         = var.environment
  eks_cluster_name    = module.eks.cluster_name
  eks_oidc_provider   = module.eks.oidc_provider
  eks_oidc_provider_arn = module.eks.oidc_provider_arn
}

# ACM Module
module "acm" {
  source = "./modules/acm"

  domain_name = var.domain_name
  environment = var.environment
  zone_id     = module.route53.zone_id
}

# Route53 Module
module "route53" {
  source = "./modules/route53"

  domain_name = var.domain_name
  environment = var.environment
  create_zone = false # Use existing zone
}

# ExternalDNS Module
module "external_dns" {
  source = "./modules/external-dns"

  environment           = var.environment
  domain_name           = var.domain_name
  eks_cluster_name      = module.eks.cluster_name
  eks_oidc_provider_arn = module.eks.oidc_provider_arn

  depends_on = [module.eks, module.route53]
}

# Secrets Manager Module
module "secrets_manager" {
  source = "./modules/secrets-manager"

  project_name   = var.project_name
  environment    = var.environment
  create_secrets = var.create_secrets
}

# S3 Module
module "s3" {
  source = "./modules/s3"

  project_name        = var.project_name
  environment         = var.environment
  enable_versioning   = var.enable_s3_versioning
  backend_role_arn    = module.iam.backend_role_arn
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  project_name              = var.project_name
  environment               = var.environment
  eks_cluster_name          = module.eks.cluster_name
  vpc_id                    = module.vpc.vpc_id
  alb_controller_role_arn   = module.iam.alb_controller_role_arn
  
  depends_on = [module.eks]
}

# ArgoCD Module
module "argocd" {
  source = "./modules/argocd"

  enabled          = var.argocd_enabled
  chart_version    = var.argocd_version
  eks_cluster_name = module.eks.cluster_name
  domain_name      = var.domain_name
  environment      = var.environment
  gitops_repo_url  = var.gitops_repo_url
  
  depends_on = [module.eks, module.alb]
}

# Configure Kubernetes and Helm providers after EKS cluster is created
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name,
      "--region",
      var.aws_region
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name,
        "--region",
        var.aws_region
      ]
    }
  }
}


