output "aws_region" {
  description = "AWS region"
  value       = try(data.aws_region.current.id, null)
}

output "iam_management" {
  description = "Identity and Access Management"
  value       = try(data.aws_caller_identity.current, null)
}

output "sns_topic_name" {
  description = "SNS topic name"
  value       = try(data.aws_sns_topic.iam_security_alerts.name, aws_sns_topic.iam_security_alerts.name, null)
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket for logs"
  value       = try(aws_s3_bucket.cloudtrail_events_bucket.bucket_domain_name, null)
}

# output "s3_bucket_id" {
#   description = "Id of the S3 bucket for logs"
#   value       = try(aws_s3_bucket.cloudtrail_events_bucket.id, null)
# }

output "s3_bucket_name" {
  description = "Name of the S3 bucket for logs"
  value       = try(aws_s3_bucket.cloudtrail_events_bucket.bucket, null)
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = try(data.aws_lambda_function.iam_event_monitor.function_name, aws_lambda_function.iam_event_monitor.function_name, null)
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = try(data.aws_cloudwatch_log_group.lambda_function_log_group.name, aws_cloudwatch_log_group.lambda_function_log_group.name, null)
}

output "lambda_log_group_retention_in_days" {
  description = "NUmber of retention days for lambda log group"
  value       = try(data.aws_cloudwatch_log_group.lambda_function_log_group.retention_in_days, aws_cloudwatch_log_group.lambda_function_log_group.retention_in_days, null)
}
