# S3 Bucket for CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_events_bucket" {
  bucket = lower("cloudtrail-events-bucket-${var.environment}-${random_string.bucket_suffix.result}")
  # force_destroy = true

  timeouts {
    create = "5m"
    delete = "20m"
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_events_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_events_bucket.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_events_bucket.arn}/*"
        # Condition = {
        #   StringEquals = {
        #     "s3:x-amz-acl" = "bucket-owner-full-control"
        #   }
        # }
      }
    ]
  })
}

# S3 Bucket ACL Configuration
resource "aws_s3_bucket_public_access_block" "cloudtrail_public_access_block" {
  bucket = aws_s3_bucket.cloudtrail_events_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Versioning
# resource "aws_s3_bucket_versioning" "cloudtrail_bucket_versioning" {
#   bucket = aws_s3_bucket.cloudtrail_events_bucket.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# S3 Bucket Lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_bucket_lifecycle" {
  bucket = aws_s3_bucket.cloudtrail_events_bucket.id

  rule {

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    filter {}

    id     = "cleanup_old_logs"
    status = "Enabled"

    expiration {
      days = 7
    }
  }
}

resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  lower   = true
  numeric = true
}
