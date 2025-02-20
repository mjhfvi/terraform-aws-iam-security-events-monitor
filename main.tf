terraform {
  required_version = ">= 1.10.5"
}

module "iam_security_events" {
  source                              = "./modules/"
  aws_access_key                      = var.aws_access_key
  aws_secret_key                      = var.aws_secret_key
  environment                         = var.environment
  project_owner                       = var.project_owner
  project_name                        = var.project_name
  enable_notification_email           = var.enable_notification_email
  notification_email                  = var.notification_email
  enable_notification_phone           = var.enable_notification_phone
  notification_phone                  = var.notification_phone
  enable_opensearch                   = var.enable_opensearch
  aws_opensearch_domain_instance_type = var.aws_opensearch_domain_instance_type
  cloudwatch_log_retention_days       = var.cloudwatch_log_retention_days
  lambda_function_log_retention_days  = var.lambda_function_log_retention_days
  lambda_function_timeout             = var.lambda_function_timeout
  opensearch_master_user_name         = var.opensearch_master_user_name
  opensearch_master_user_password     = var.opensearch_master_user_password
  opensearch_ebs_volume_size          = var.opensearch_ebs_volume_size

}
