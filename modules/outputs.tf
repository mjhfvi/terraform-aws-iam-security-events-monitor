output "aws_region" {
  description = "AWS region"
  value       = try(data.aws_region.current.id, null)

  precondition {
    condition     = data.aws_region.current.id == "us-east-1"
    error_message = "the aws region must be us-east-1, as IAM Events are only available in us-east-1"
  }
}

output "iam_management" {
  description = "Identity and Access Management"
  value       = try(data.aws_caller_identity.current.arn, null)
}

output "sns_topic_name" {
  description = "SNS topic name"
  value       = try(data.aws_sns_topic.iam_security_alerts.name, aws_sns_topic.iam_security_alerts.name, null)
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket for logs"
  value       = try(data.aws_s3_bucket.cloudtrail_events_bucket.bucket_domain_name, aws_s3_bucket.cloudtrail_events_bucket.bucket_domain_name, null)
}

output "s3_bucket_id" {
  description = "Id of the S3 bucket for logs"
  value       = try(data.aws_s3_bucket.cloudtrail_events_bucket.id, aws_s3_bucket.cloudtrail_events_bucket.id, null)
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for logs"
  value       = try(data.aws_s3_bucket.cloudtrail_events_bucket.bucket, aws_s3_bucket.cloudtrail_events_bucket.bucket, null)
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
  description = "Number of retention days for lambda log group"
  value       = try(aws_cloudwatch_log_group.lambda_function_log_group.retention_in_days, data.aws_cloudwatch_log_group.lambda_function_log_group.retention_in_days, null)
}

# output "opensearch_domain_name" {
#   description = "opensearch domain name"
#   value       = try(data.aws_opensearch_domain.cloudtrail_logs.domain_name, null)
# }

# output "opensearch_url" {
#   description = "opensearch url"
#   value       = try(aws_opensearch_domain.cloudtrail_logs[count.index].endpoint, null)
# }
