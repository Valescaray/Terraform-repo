variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "create_secrets" {
  description = "Whether to create secrets"
  type        = bool
  default     = true
}
