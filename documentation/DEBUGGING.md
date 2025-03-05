# Debugging AWS with Terraform

### set aws config file for cli

- edit aws config file: ~/.aws/credentials

```bash
[default] \
aws_access_key_id= \
aws_secret_access_key= \
region= \
output=
```

### adit aws users

```bash
aws iam list-users
aws iam get-user --user-name test01
aws iam create-user --user-name test01
```

### query aws lambda

```bash
aws lambda list-functions
aws lambda get-function --function-name FUNCTION_NAME
aws lambda invoke --function-name FUNCTION_NAME --cli-binary-format raw-in-base64-out --payload '{ "name": "Bob" }' response.json
```

### qurery aws resources

```bash
aws logs get-log-events --log-group-name GROUP_LOGS --log-stream-name STREAM_LOGS
aws logs describe-log-groups
aws logs describe-log-streams --log-group-name CLOUDTRAIL_LOGS
```

### update terraform resources

```bash
terraform apply -replace="RESOURCE_MODULE.RESOURCE_TYPE" -var-file="secret.tfvars" -auto-approve
```

- Example:

```
terraform apply -replace="aws_iam_policy_document.lambda_logging" -var-file="secret.tfvars" -auto-approve
```

## CloudTrail Log Access, run this command, then build terraform user

```bash
aws organizations enable-aws-service-access --service-principal cloudtrail.amazonaws.com
aws iam create-user --user-name USER_NAME
aws iam attach-user-policy --user-name USER_NAME --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam list-attached-user-policies --user-name USER_NAME
```

```bash
aws iam list-policies
aws iam get-account-authorization-details
aws sts get-caller-identity
```

```bash
aws cloudtrail describe-trails
aws cloudtrail get-trail --name TRAIL_NAME
aws cloudtrail get-trail-status --name TRAIL_NAME
aws cloudtrail get-event-selectors --trail-name TRAIL_NAME

aws cloudtrail get-trail --name TRAIL_NAME --query 'Trail.{Name:Name,IsMultiRegionTrail:IsMultiRegionTrail,IncludeGlobalEvents:IncludeGlobalServiceEvents}'
```

```bash
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=CreateUser --region us-east-1 --start-time "2025-02-12T12:00:00+02:00"
```

### remove SNS Pending confirmation

```bash
aws sns list-subscriptions
```
