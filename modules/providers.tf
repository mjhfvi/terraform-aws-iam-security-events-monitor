## https://registry.terraform.io/providers/hashicorp/aws/latest/docs
terraform {
  required_version = ">= 5.86.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.86.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    archive = {
      source  = "hashicorp/random"
      version = "2.7.0"
    }
  }

  # configure backend
  # backend "s3" {
  #   bucket = "terraform-state-bucket"
  #   key    = "security-monitor/terraform.tfstate"
  #   region = "us-west-1"
  # }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  default_tags {
    tags = {
      Project_Name     = var.project_name
      Environment      = var.environment
      Owner_Name       = var.project_owner
      Provisioned_With = var.provisioned_with
    }
  }
}
