variable "create_zone" {
  description = "Whether to create the Route53 zone or use an existing one"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Domain name for the Route53 zone"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
