output "aws_region" {
  description = "AWS region"
  value       = try(module.iam_security_events.aws_region, null)
}

output "iam_management" {
  description = "Identity and Access Management"
  value       = try(module.iam_security_events.iam_management, null)
}

output "sns_topic_name" {
  description = "SNS topic name"
  value       = try(module.iam_security_events.sns_topic_name, null)
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket for logs"
  value       = try(module.iam_security_events.s3_bucket_domain_name, null)
}

output "s3_bucket_id" {
  description = "Id of the S3 bucket for logs"
  value       = try(module.iam_security_events.s3_bucket_id, null)
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for logs"
  value       = try(module.iam_security_events.s3_bucket_name, null)
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = try(module.iam_security_events.lambda_function_name, null)
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = try(module.iam_security_events.cloudwatch_log_group_name, null)
}

output "lambda_log_group_retention_in_days" {
  description = "Number of retention days for lambda log group"
  value       = try(module.iam_security_events.lambda_log_group_retention_in_days, null)
}

# output "opensearch_domain_name" {
#   description = "opensearch domain name"
#   value       = try(module.iam_security_events.opensearch_domain_name, null)
# }

# output "opensearch_url" {
#   description = "opensearch url"
#   value       = try(module.iam_security_events.opensearch_url, null)
# }
