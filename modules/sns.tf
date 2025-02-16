# SNS Topic for alerts
resource "aws_sns_topic" "iam_security_alerts" {
  name = "lambda-security-alerts"
}

# SNS Topic Email Subscription
resource "aws_sns_topic_subscription" "email" {
  count     = var.aws_sns_topic_subscription_email == "" ? 0 : 1
  topic_arn = aws_sns_topic.iam_security_alerts.arn
  protocol  = "email-json"
  endpoint  = var.notification_email
  # pending_confirmation = false
}

# SNS Topic SMS Subscription
# resource "aws_sns_topic_subscription" "sms" {
#   count     = var.aws_sns_topic_subscription_sms == "" ? 0 : 1
#   topic_arn = aws_sns_topic.iam_security_alerts.arn
#   protocol  = "sms"
#   endpoint  = var.notification_phone
#   # pending_confirmation = false
# }
