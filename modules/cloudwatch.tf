# CloudWatch Event Rules for cloudtrail logs
resource "aws_cloudwatch_event_rule" "lambda_cloudwatch_events_rule" {
  name        = "lambda-cloudwatch-events-rule"
  description = "Capture CloudWatch IAM Events for Lambda"

  event_pattern = jsonencode({
    source      = ["aws.iam"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["iam.amazonaws.com"]
      eventName   = [local.all_actions_string]
    }
  })
}

# CloudWatch Event Role
resource "aws_iam_role" "cloudwatch_role" {
  name = "cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
      }
    ]
  })
}

# CloudWatch Event Targets for lambda
resource "aws_cloudwatch_event_target" "lambda_cloudwatch_event_target" {
  rule      = aws_cloudwatch_event_rule.lambda_cloudwatch_events_rule.name
  target_id = "SecurityMonitorLambda"
  arn       = aws_lambda_function.iam_event_monitor.arn
}

# Local variables to manage actions
locals {
  user_actions = var.enable_user_actions ? [
    "CreateUser",
    "UpdateUser",
    "DeleteUser"
  ] : []

  group_actions = var.enable_group_actions ? [
    "CreateGroup",
    "UpdateGroup",
    "DeleteGroup"
  ] : []

  user_accesskey_actions = var.enable_user_accesskey_actions ? [
    "CreateAccessKey",
    "DeleteAccessKey"
  ] : []

  # Combine all actions
  all_actions        = concat(local.user_actions, local.user_accesskey_actions, local.group_actions)
  all_actions_string = join(", ", local.all_actions)
}
