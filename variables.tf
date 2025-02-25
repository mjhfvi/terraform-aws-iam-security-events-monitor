variable "aws_access_key" {
  description = "AWS access_key, admin login permissions to AWS resources"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "aws_secret_key" {
  description = "AWS secret_key, admin login permissions to AWS resources"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "project_owner" {
  description = "set the tag for environment project owner name, a person or depatment"
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

variable "enable_notification_email" {
  description = "Enable/Disable user email address notifications"
  type        = bool
  default     = true
  nullable    = true
}

variable "enable_notification_phone" {
  description = "Enable/Disable user phone address notifications"
  type        = bool
  default     = false
  nullable    = true
}

variable "notification_email" {
  description = "List user email address notifications"
  type        = list(string)
  default     = []
  nullable    = true
}

variable "notification_phone" {
  description = "List user phone number notifications"
  type        = list(string)
  default     = []
  nullable    = true
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
  description = "Timeout for lambda function"
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
  description = "Enable/Disable OpenSearch for monitoring logs from CloudTrail"
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
  default     = "admin1admin1"
  nullable    = false
  sensitive   = true

  validation {
    condition     = length(var.opensearch_master_user_password) >= 8
    error_message = "master user password must have length greater than or equal to 8 characters with a number"
  }
}

variable "opensearch_ebs_volume_size" {
  description = "Set opensearch ebs volume size"
  type        = number
  default     = 10
  nullable    = false

  validation {
    condition     = var.opensearch_ebs_volume_size >= 10
    error_message = "ebs volume size must be equal or greater than 10"
  }
}

variable "enable_user_actions" {
  description = "Enable/Disable user actions lambda function for cloudwatch events rule"
  type        = bool
  default     = true
  nullable    = true
}

variable "enable_group_actions" {
  description = "Enable/Disable group actions lambda function for cloudwatch events rule"
  type        = bool
  default     = false
  nullable    = true
}

variable "enable_user_accesskey_actions" {
  description = "Enable/Disable user accesskey actions lambda function for cloudwatch events rule"
  type        = bool
  default     = true
  nullable    = true
}
