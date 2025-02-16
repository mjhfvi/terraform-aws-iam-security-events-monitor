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
  source_file = "${path.root}/lambda/iam_event_monitor.py"
  output_path = "${path.root}/lambda/iam_event_monitor.zip"
}

resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  lower   = true
  numeric = true
}