module "iam_security_events" {
  source                             = "./modules/"
  aws_access_key                     = var.aws_access_key
  aws_secret_key                     = var.aws_secret_key
  environment                        = var.environment
  owner_name                         = var.owner_name
  project_name                       = var.project_name
  notification_email                 = var.notification_email
  notification_phone                 = var.notification_phone
  cloudwatch_log_retention_days      = 14
  lambda_function_log_retention_days = 7
  lambda_function_timeout            = 60
}