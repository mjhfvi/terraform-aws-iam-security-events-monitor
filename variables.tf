variable "aws_access_key" {
  description = "AWS access_key to use for the server"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "aws_secret_key" {
  description = "AWS secret_key to use for the server"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
  nullable    = false
}

variable "owner_name" {
  description = "environment owner name"
  type        = string
  default     = null
  nullable    = true
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = null
  nullable    = true
}

variable "notification_email" {
  description = "User email address notifications"
  type        = string
  default     = null
  nullable    = true
}

variable "notification_phone" {
  description = "User phone number notifications"
  type        = string
  default     = null
  nullable    = true
}

variable "environment" {
  description = "AWS Environment (Development, Testing, Staging, Production)"
  type        = string
  # default     = null
  nullable = true

  validation {
    condition     = var.environment == "Development" || var.environment == "Testing" || var.environment == "Staging" || var.environment == "Production"
    error_message = "The environment value must be one of: Development, Testing, Staging, Production"
  }
}

