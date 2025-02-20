# Lambda Function
resource "aws_lambda_function" "iam_event_monitor" {
  description                    = "lambda function to monitor security events"
  filename                       = data.archive_file.iam_event_monitor.output_path
  function_name                  = "iam_event_monitor"
  role                           = aws_iam_role.lambda_logs_events_role.arn
  handler                        = "iam_event_monitor.lambda_handler"
  runtime                        = var.lambda_runtime
  timeout                        = var.lambda_function_timeout
  reserved_concurrent_executions = 10 # Set the maximum number of concurrent executions (Testing only)

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      SNS_TOPIC_ARN       = aws_sns_topic.iam_security_alerts.arn
      LOG_BUCKET          = aws_s3_bucket.cloudtrail_events_bucket.id
      BEDROCK_MODEL       = "anthropic.claude-v2"
      OPENSEARCH_ENDPOINT = var.enable_opensearch != true ? 0 : aws_opensearch_domain.cloudtrail_logs[0].arn
    }
  }
}

# CloudWatch Logs for lambda
resource "aws_cloudwatch_log_group" "lambda_function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.iam_event_monitor.function_name}"
  retention_in_days = var.lambda_function_log_retention_days
}

# Lambda IAM (Identity and Access Management) role
resource "aws_iam_role" "lambda_logs_events_role" {
  name = "lambda-function-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda IAM policy for IAM role
resource "aws_iam_policy" "lambda_logs_events_policy" {
  name = "lambda-logs-events-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          # "*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "sns:Publish",
          "s3:PutObject",
          "s3:GetObject"
        ],
        Effect = "Allow",
        Resource = [
          # "*",
          aws_sns_topic.iam_security_alerts.arn,
          "${aws_cloudwatch_log_group.lambda_function_log_group.arn}:*",
          "${aws_s3_bucket.cloudtrail_events_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Lambda permission to allow EventBridge
resource "aws_lambda_permission" "eventbridge_event_logs_trigger" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.iam_event_monitor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_cloudwatch_events_rule.arn
}

# Attach AWSLambdaBasicExecutionRole policy to the IAM Role
resource "aws_iam_role_policy_attachment" "lambda_log_events_policy_attachment" {
  for_each = tomap({
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    policy_arn = aws_iam_policy.lambda_logs_events_policy.arn
  })
  role       = aws_iam_role.lambda_logs_events_role.name
  policy_arn = each.value
}
