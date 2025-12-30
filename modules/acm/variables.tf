variable "domain_name" {
  description = "Domain name for the certificate"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "zone_id" {
  description = "Route53 hosted zone ID for DNS validation"
  type        = string
}

variable "subject_alternative_names" {
  description = "Subject alternative names for the certificate"
  type        = list(string)
  default     = []
}
