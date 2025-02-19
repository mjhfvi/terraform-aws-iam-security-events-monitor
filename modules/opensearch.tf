# Create OpenSearch Domain
resource "aws_opensearch_domain" "cloudtrail_logs" {
  count          = var.enable_opensearch != true ? 0 : 1
  domain_name    = "cloudtrail-logs"
  engine_version = "OpenSearch_2.17"

  cluster_config {
    instance_type  = var.aws_opensearch_domain_instance_type
    instance_count = 1
    # zone_awareness_enabled = true
    # zone_awareness_config {
    #   availability_zone_count = 2
    # }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.opensearch_ebs_volume_size
  }

  #   encrypt_at_rest {
  #     enabled = true
  #   }

  node_to_node_encryption {
    enabled = true
  }

  #   domain_endpoint_options {
  #     enforce_https       = true
  #     tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  #   }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    # anonymous_auth_enabled         = true

    master_user_options {
      master_user_name     = var.opensearch_master_user_name
      master_user_password = var.opensearch_master_user_password
    }
  }

  # log_publishing_options {
  #   cloudwatch_log_group_arn = aws_cloudwatch_log_group.cloudtrail_logs_events_log_group.arn
  #   log_type                 = "AUDIT_LOGS" # Valid values: INDEX_SLOW_LOGS, SEARCH_SLOW_LOGS, ES_APPLICATION_LOGS, AUDIT_LOGS.
  # }

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "es:ESHttp*"
        ]
        Resource = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/cloudtrail-logs/*"
      }
    ]
  })
}

# Create IAM Role for CloudTrail
resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail-opensearch-role"

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

# Create IAM Policy for CloudTrail to OpenSearch
resource "aws_iam_role_policy" "cloudtrail_policy" {
  count = var.enable_opensearch != true ? 0 : 1
  name  = "cloudtrail-opensearch-policy"
  role  = aws_iam_role.cloudtrail_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "es:ESHttp*"
        ]
        Resource = "${aws_opensearch_domain.cloudtrail_logs[count.index].arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail_logs_events_log_group.arn}:*"
      }
    ]
  })
}
