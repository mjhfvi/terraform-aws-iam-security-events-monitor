# CloudTrail
resource "aws_cloudtrail" "cloudtrail_iam_events" {
  name                          = "cloudtrail-iam-events-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_events_bucket.id
  include_global_service_events = true
  enable_log_file_validation    = true
  is_organization_trail         = true # set to true to get events from all accounts
  is_multi_region_trail         = true # set to true to get events from all regions
  enable_logging                = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_logs_events_log_group.arn}:*" # CloudTrail requires the Log Stream wildcardaws_cloudwatch_log_group.cloudtrail_logs_events_log_group.arn
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_logs_events_role.arn
  sns_topic_name                = aws_sns_topic.iam_security_alerts.name

  depends_on = [aws_s3_bucket_policy.cloudtrail_bucket_policy]
}

# CloudWatch Logs for cloudtrail
resource "aws_cloudwatch_log_group" "cloudtrail_logs_events_log_group" {
  name              = "/aws/cloudtrail/cloudtrail-logs-events"
  retention_in_days = var.cloudwatch_log_retention_days
}

# CloudTrail IAM (Identity and Access Management) role
resource "aws_iam_role" "cloudtrail_logs_events_role" {
  name = "cloudtrail-logs-events-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })
}

# CloudTrail IAM policy for IAM role
resource "aws_iam_role_policy" "cloudtrail_logs_events_log_policy" {
  name = "cloudtrail-logs-events-log-policy"
  role = aws_iam_role.cloudtrail_logs_events_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # "*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          # "*",
          aws_cloudwatch_log_group.cloudtrail_logs_events_log_group.arn,
          aws_s3_bucket.cloudtrail_events_bucket.arn,
          aws_sns_topic.iam_security_alerts.arn
        ]
      }
    ]
  })
}
