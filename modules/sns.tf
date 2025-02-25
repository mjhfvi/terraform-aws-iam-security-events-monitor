# SNS Topic for alerts
resource "aws_sns_topic" "iam_security_alerts" {
  name         = "iam-security-alerts"
  display_name = "SNS Topic for IAM Security Alerts"
}

# SNS Topic Email Subscription
resource "aws_sns_topic_subscription" "email" {
  for_each                        = var.enable_notification_email != true ? toset(var.notification_email) : []
  topic_arn                       = aws_sns_topic.iam_security_alerts.arn
  protocol                        = "email-json" # email or email-json
  endpoint                        = each.key
  confirmation_timeout_in_minutes = 5
  # pending_confirmation = false
}

# SNS Topic SMS Subscription
resource "aws_sns_topic_subscription" "sms" {
  for_each  = var.enable_notification_phone != true ? toset(var.notification_phone) : []
  topic_arn = aws_sns_topic.iam_security_alerts.arn
  protocol  = "sms"
  endpoint  = each.key
}

# SNS Topic Policy

resource "aws_sns_topic_policy" "cloudtrail_sns_policy" {
  arn = aws_sns_topic.iam_security_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailSNSPolicy"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.iam_security_alerts.arn
      }
    ]
  })
}
