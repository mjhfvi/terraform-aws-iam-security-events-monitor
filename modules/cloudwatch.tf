# CloudWatch Event Rules for cloudtrail logs
resource "aws_cloudwatch_event_rule" "lambda_cloudwatch_events_rule" {
  name        = "lambda-cloudwatch-events-rule"
  description = "Capture cloudwatch iam events for lambda"

  event_pattern = jsonencode({
    source      = ["aws.iam"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["iam.amazonaws.com"]
      eventName = [
        "CreateUser",
        "UpdateUser",
        "DeleteUser",
        "CreateGroup",
        "UpdateGroup",
        "DeleteGroup",
        "CreateAccessKey",
        "DeleteAccessKey",
        "ListGroupsForUser",
      ]
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
