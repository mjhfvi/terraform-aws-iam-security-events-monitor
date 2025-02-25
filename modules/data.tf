data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_sns_topic" "iam_security_alerts" {
  name = aws_sns_topic.iam_security_alerts.name
}

data "aws_cloudwatch_log_group" "lambda_function_log_group" {
  name = aws_cloudwatch_log_group.lambda_function_log_group.name
}

data "aws_lambda_function" "iam_event_monitor" {
  function_name = aws_lambda_function.iam_event_monitor.function_name
}

data "archive_file" "iam_event_monitor" {
  type        = "zip"
  source_file = "${path.module}/../function/iam_event_monitor.py"
  output_path = "${path.module}/../function/iam_event_monitor.zip"
}

# data "archive_file" "rag_db_query" {
#   type        = "zip"
#   source_file = "${path.module}/../function/rag_db_query.py"
#   output_path = "${path.module}/../function/rag_db_query.zip"
# }

data "aws_s3_bucket" "cloudtrail_events_bucket" {
  bucket = aws_s3_bucket.cloudtrail_events_bucket.id
}

data "aws_opensearch_domain" "cloudtrail_logs" {
  count       = var.enable_opensearch ? 1 : 0
  domain_name = var.enable_opensearch ? aws_opensearch_domain.cloudtrail_logs[count.index].domain_name : null
}
