variable "aws_access_key" {
  description = "AWS access_key, admin login permissions to AWS resources"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret_key, admin login permissions to AWS resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
  nullable    = false
}

variable "project_owner" {
  description = "set the tag for environment project owner name, a person or depatment"
  type        = string
}

variable "project_name" {
  description = "set the tag for name of the project"
  type        = string
}

variable "environment" {
  description = "AWS Environment (Development, Testing, Staging, Production)"
  type        = string
}

variable "provisioned_with" {
  description = "provisioned AWS resources with automation tool (terraform)"
  type        = string
  default     = "Terraform"
  nullable    = false
}

variable "enable_notification_email" {
  description = "Enable/Disable user email address notifications for SNS topic"
  type        = bool
}

variable "enable_notification_phone" {
  description = "Enable/Disable phone address address notifications for SNS topic"
  type        = bool
}

variable "notification_email" {
  description = "List user email address notifications"
  type        = list(string)
}

variable "notification_phone" {
  description = "List user phone number notifications"
  type        = list(string)
}

variable "cloudwatch_log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
}

variable "lambda_function_timeout" {
  description = "Timeout for lambda function"
  type        = number
}

variable "lambda_runtime" {
  description = "Code runtime for the Lambda function"
  type        = string
  default     = "python3.12"
  nullable    = false
}

variable "lambda_function_log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
}

variable "aws_opensearch_domain_instance_type" {
  description = "AWS opensearch domain instance type"
  type        = string
}

variable "enable_opensearch" {
  description = "Enable/Disable OpenSearch for monitoring logs from CloudTrail"
  type        = bool
}

variable "opensearch_master_user_name" {
  description = "Set opensearch user name login"
  type        = string
}

variable "opensearch_master_user_password" {
  description = "Set opensearch user name login password"
  type        = string
}

variable "opensearch_ebs_volume_size" {
  description = "Set opensearch ebs volume size"
  type        = number
}

variable "enable_user_actions" {
  description = "Enable/Disable user actions lambda function for cloudwatch events rule"
  type        = bool
}

variable "enable_group_actions" {
  description = "Enable/Disable group actions lambda function for cloudwatch events rule"
  type        = bool
}

variable "enable_user_accesskey_actions" {
  description = "Enable/Disable user accesskey actions lambda function for cloudwatch events rule"
  type        = bool
}
