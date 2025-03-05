# Limitations and Assumptions

---

### Terraform variables validations

- S3 bucket retention days must be greater than 7 days

### Amazon EventBridge

- IAM events only logs in us-east-1 region as it is a global resource
- log IAM events in other regions, use CloudTrail and set 'IncludeGlobalServiceEvents' to true

### SNS Topic

- using 'email' as notification will get some unwanted conformation emails, use 'email-json'

### CloudWatch Events

- logging cloudwatch event time is about 2-3 min, so be patient
  searching events in "Log events" is case sensitive

### Lambda

- The Lambda function timeout is set to 30 seconds

### S3 bucket

- when destroying S3 bucket you need to empty it first, Error example:

```
"Error: deleting S3 Bucket (cloudtrail-events-bucket-development-fdi3eu): operation error S3: DeleteBucket, https response error StatusCode: 409, RequestID: ID, HostID: ID, api error BucketNotEmpty: The bucket you tried to delete is not empty"
```
