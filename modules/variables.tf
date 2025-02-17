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

variable "enable_notification_email" {
  description = "User email address notifications"
  type        = string
  default     = true
  nullable    = true
}

variable "enable_notification_phone" {
  description = "User phone address notifications"
  type        = string
  default     = false
  nullable    = true
}

variable "notification_email" {
  description = "User email address notifications"
  type        = list(string)
  # default     = null
  nullable = true
}

variable "notification_phone" {
  description = "User phone number notifications"
  type        = list(string)
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

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.12"
  nullable    = false
}

variable "aws_sns_topic_subscription_sms" {
  description = "phone number for sms sns topic subscription"
  # type        = bool
  default  = null
  nullable = true
}

variable "aws_sns_topic_subscription_email" {
  description = "email for sns topic subscription"
  # type        = bool
  default  = null
  nullable = true
}

variable "cloudwatch_log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 14
  nullable    = false

  validation {
    condition     = var.cloudwatch_log_retention_days >= 14
    error_message = "Number of days to retain CloudWatch logs (cloudtrail_logs_events_log_group) must be equal or greater than 14 days"
  }
}

variable "lambda_function_log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 7
  nullable    = false

  validation {
    condition     = var.lambda_function_log_retention_days >= 7
    error_message = "Number of days to retain Lambda function logs (lambda_function_log_group) must be equal or greater than 7 days"
  }
}

variable "lambda_function_timeout" {
  description = "lambda function timeout"
  type        = number
  default     = 30
  nullable    = false

  validation {
    condition     = var.lambda_function_timeout >= 30
    error_message = "The number seconds before lambda function times out, should be equal or greater than 30 seconds"
  }
}

