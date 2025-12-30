# Variables Reference

## Global Variables
| Name | Description | Default |
|------|-------------|---------|
| `project_name` | Name of the project | invoice-analyzer |
| `environment` | Environment (dev, prod) | - |
| `aws_region` | AWS Region | us-west-2 |
| `domain_name` | Base domain name | oppsdev.xyz |

## VPC
| Name | Description | Default |
|------|-------------|---------|
| `vpc_cidr` | Network CIDR | 10.0.0.0/16 |
| `availability_zones` | AZs to deploy into | [us-west-2a, 2b, 2c] |
| `single_nat_gateway` | Use 1 NAT GW to save costs | false |

## EKS
| Name | Description | Default |
|------|-------------|---------|
| `eks_cluster_version` | K8s version | 1.28 |
| `eks_node_instance_types` | Node instance types | [t3.medium] |
| `eks_node_desired_size` | Desired node count | 2 |
| `eks_node_min_size` | Min node count | 1 |
| `eks_node_max_size` | Max node count | 4 |

## ArgoCD
| Name | Description | Default |
|------|-------------|---------|
| `argocd_enabled` | Install ArgoCD | true |
| `argocd_version` | Helm chart version | 5.51.0 |

## Storage & Secrets
| Name | Description | Default |
|------|-------------|---------|
| `create_secrets` | Create Secrets Manager secrets | true |
| `enable_s3_versioning` | Enable bucket versioning | true |
