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

# variable "aws_region" {
#   description = "AWS region"
#   type        = string
#   default     = "us-east-1"
#   nullable    = false
# }

variable "project_owner" {
  description = "set the tag for environment project owner name, a person or a depatment"
  type        = string
  default     = null
  nullable    = true
}

variable "project_name" {
  description = "set the tag for name of the project"
  type        = string
  default     = null
  nullable    = true
}

# variable "provisioned_with" {
#   description = "provisioned resource with tool name (terraform)"
#   type        = string
#   default     = "Terraform"
#   nullable    = false
# }

# variable "enable_notification_email" {
#   description = "User email address notifications"
#   type        = string
#   default     = false
#   nullable    = true
# }

# variable "enable_notification_phone" {
#   description = "User phone address notifications"
#   type        = string
#   default     = false
#   nullable    = true
# }

variable "notification_email" {
  description = "User email address notifications"
  type        = list(string)
  default     = []
  nullable    = true
}

variable "notification_phone" {
  description = "User phone number notifications"
  type        = list(string)
  default     = []
  nullable    = true
}

variable "environment" {
  description = "AWS Environment (Development, Testing, Staging, Production)"
  type        = string
  default     = "Testing"
  nullable    = true

  validation {
    condition     = var.environment == "Development" || var.environment == "Testing" || var.environment == "Staging" || var.environment == "Production"
    error_message = "The environment value must be one of: Development, Testing, Staging, Production"
  }
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

variable "enable_notification_email" {
  description = "User email address notifications"
  type        = bool
  default     = true
  nullable    = true
}

variable "enable_notification_phone" {
  description = "User phone address notifications"
  type        = bool
  default     = false
  nullable    = true
}

variable "aws_opensearch_domain_instance_type" {
  description = "aws opensearch domain instance type"
  type        = string
  default     = "t3.small.search"
  nullable    = false

  validation {
    condition     = var.aws_opensearch_domain_instance_type == "t3.small.search"
    error_message = "The aws opensearch domain instance type must be t3.small.search (Testing Only)"
  }
}

variable "enable_opensearch" {
  description = "Enable OpenSearch for monitoring logs from CloudTrail"
  type        = bool
  default     = false
  nullable    = true
}

variable "opensearch_master_user_name" {
  description = "Set opensearch user name login"
  type        = string
  default     = "admin"
  nullable    = false
  sensitive   = true
}

variable "opensearch_master_user_password" {
  description = "Set opensearch user name login password"
  type        = string
  default     = "admin"
  nullable    = false
  sensitive   = true
}


variable "opensearch_ebs_volume_size" {
  description = "Set opensearch user name login password"
  type        = number
  default     = 10
  nullable    = false
}
