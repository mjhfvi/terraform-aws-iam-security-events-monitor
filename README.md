# Terraform Module to Alert IAM Resources use
---
### Table of Contents

  - [AWS Security Monitoring Solution](#aws-security-monitoring-solution)
  - [Architecture](#architecture)
  - [Prerequisites](#prerequisites)
  - [Overall Cost](#overall-cost)
  - [Directory Structure](#directory-structure)
    - [CloudWatch](#cloudwatch)
    - [Lambda](#lambda)
    - [Provider](#provider)
    - [S3 bucket](#s3-bucket)
    - [SNS](#sns)
    - [Variables](#variables)
    - [Data](#data)
    - [Outputs](#outputs)
  - [Deployment Instructions](#deployment-instructions)
    - [From Terraform Registry](#from-terraform-registry)
    - [From Source](#from-source)
  - [Cleanup](#cleanup)
  - [Troubleshooting](#troubleshooting)


## AWS Security Monitoring Solution

This solution provides automated security monitoring for your AWS environment using Lambda and EventBridge. 
It monitors and alerts on critical security events including IAM user creation, access key creation, S3 bucket policy changes, and security group modifications.

## Architecture

The solution consists of:
- AWS Lambda function (Python) for processing security events
- CloudTrail for logging AWS API activity
- EventBridge(CloudWatch) rules for capturing specific security events
- SNS topic for sending notifications (email/sms)
- IAM roles and policies for secure operation
- S3 bucket for storing CloudTrail logs (mendatory for CloudTrail)

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 5.86.0
- Python 3.12 or later for the lambda function
- An AWS account with sufficient permissions to create the required resources

## Overall Cost

Checked the cost of this solution with [infracost](https://www.infracost.io/), the total estimated monthly cost is 0.00$, S3 bucket is subject to charges as more data is stored to bucket. 

## Directory Structure

```
.
├── cloudtrail.tf
├── cloudwatch.tf
├── data.tf
├── lambda.tf
├── outputs.tf
├── providers.tf
├── README.md
├── s3_bucket.tf
├── secrets.tfvars
├── sns.tf
├── variables.tf
├── lambda
│   └── lambda_function.py
|   └── lambda_payload_CreateUser.json
├── documentation
│   ├── SECURITY.md
│   ├── TESTING.md
│   ├── DEBUGGING.md
│   ├── LIMITATIONS.md
│   ├── TODO.md
│   └── TOOLS.md
```
### CloudWatch
cloudwatch_event_rule.tf = Build CloudWatch Event Rules
cloudwatch_event_target.tf = Build CloudWatch Event Targets
cloudwatch_evet_lambda_premission.tf = Build CloudWatch Event Lambda Permission

### Lambda
lambda_function.py = Lambda Function
lambda_function.tf = Build Lambda Function in AWS
lambda_function.zip = lambda_function.py used for lambda function
lambda_role.tf = Lambda Role

### Provider
providers.tf = Provider information for the project

### S3 bucket
s3_bucket.tf = S3 Bucket configuration

### SNS
sns.tf = SNS Topic configuration

### Variables
variables.tf = Variables for the project resources

### Data
data.tf = Data information for the resources

### Outputs
outputs.tf = Output project information for the user

## Deployment Instructions

### From Terraform Registry
1. Update variables in `variables.tf` if needed 
2. add main.tf
```
module "iam-security-events-monitor" {
  source             = "mjhfvi/iam-security-events-monitor/aws"
  version            = "0.1.1"
  aws_access_key     = var.aws_access_key
  aws_secret_key     = var.aws_secret_key
  environment        = var.environment
  owner_name         = var.owner_name
  project_name       = var.project_name
  notification_email = var.notification_email
  notification_phone = var.notification_phone
}
```
1. Update variables in `secret.tfvars` if needed
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review the planned changes:
   ```bash
   terraform plan -var-file="secret.tfvars" -out=plan-out
   ```
4. Apply the configuration:
   ```bash
   terraform apply "plan-out"
   ```

### From Source

1. Clone this repository
2. Update variables in `variables.tf` if needed 
3. Update variables in `secret.tfvars` if needed
4. Initialize Terraform:
   ```bash
   terraform init
   ```
5. Review the planned changes:
   ```bash
   terraform plan -var-file="secret.tfvars" -out=plan-out
   ```
6. Apply the configuration:
   ```bash
   terraform apply "plan-out"
   ```
7. Subscribe to the SNS topic (the ARN will be in the Terraform outputs)

## Cleanup

To remove all created resources:
```bash
terraform destroy -var-file="secret.tfvars" -auto-approve
```
### Post Setup
- approve the email from AWS "AWS Notification - Subscription Confirmation" by clicking the link in the email `SubscribeURL`

## Troubleshooting

Common issues and solutions:
TBD


## Terraform Documentation
[Terraform Documentation](./documentation/TERRAFORM.md)

## Security Documentation
[Security Documentation](./documentation/SECURITY.md)

## Testing Documentation
[Testing Documentation](./documentation/TESTING.md)

## Debugging Documentation
[Debugging Documentation](./documentation/DEBUGGING.md)

## Limitations Documentation
[Limitations Documentation](./documentation/LIMITATIONS.md)

## Todo Documentation
[Todo Documentation](./documentation/TODO.md)

## Tools Documentation
[Tools Documentation](./documentation/TOOLS.md)
