# SNS Topic for alerts
resource "aws_sns_topic" "iam_security_alerts" {
  name = "lambda-security-alerts"
}

# SNS Topic Email Subscription
resource "aws_sns_topic_subscription" "email" {
  for_each                        = var.enable_notification_email != true ? toset(var.notification_email) : []
  topic_arn                       = aws_sns_topic.iam_security_alerts.arn
  protocol                        = "email-json"
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
  # pending_confirmation = false
}
