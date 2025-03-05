## Testing the Solution

To test the monitoring system:

1. IAM User Creation:

   ```bash
   aws iam create-user --user-name test-user
   ```

2. Access Key Creation:

   ```bash
   aws iam create-access-key --user-name test-user
   ```

3. Security Group Rule Addition:

   ```bash
   aws ec2 authorize-security-group-ingress \
     --group-id <security-group-id> \
     --protocol tcp \
     --port 22 \
     --cidr 0.0.0.0/0
   ```

4. S3 Bucket Policy Modification:

   ```bash
   aws s3api put-bucket-policy --bucket <bucket-name> --policy file://policy.json
   ```

You should receive SNS notifications for each of these actions.

# check events flow with AWS cli

```bash
aws iam create-user --user-name test01
aws cloudtrail lookup-events --region us-east-1 --lookup-attributes AttributeKey=EventName,AttributeValue=CreateUser --max-results 10
aws cloudtrail lookup-events --region eu-west-1 --lookup-attributes AttributeKey=EventName,AttributeValue=CreateUser --max-results 10
```

```bash
aws s3 cp s3://scylladb-security-monitor/AWSLogs/o-cxkfuitcyr/770263851087/CloudTrail/us-east-1/2025/02/12/ . --recursive
gzip -d *.gz
cat *.json | jq '.Records[] | select(.eventName == "CreateUser" and .eventSource == "iam.amazonaws.com")'
```

```bash
aws logs filter-log-events --log-group-name /aws/lambda/ScyllaDB-security-monitor-lambda-function --filter-pattern '{ $.eventName = "CreateUser" }' --max-items 10 | jq '.events[] | {timestamp: (.timestamp / 1000 | strftime("%Y-%m-%d %H:%M:%S")), message: .message}'
```

```bash
aws lambda invoke \
    --function-name ScyllaDB-security-monitor-lambda-function \
    --payload '{
            "EventId": "58ac7cc5-42ab-47e1-8998-6e34e488d14f",
            "EventName": "CreateUser",
            "ReadOnly": "false",
            "AccessKeyId": "AKIA3GV2NUBHVYSQM3V2",
            "EventTime": "2025-02-12T20:08:11+02:00",
            "EventSource": "iam.amazonaws.com",
            "Username": "terraform_init",
            "Resources": [
                {
                    "ResourceType": "AWS::IAM::User",
                    "ResourceName": "AIDA3GV2NUBHSYM5CH6U4"
                },
                {
                    "ResourceType": "AWS::IAM::User",
                    "ResourceName": "arn:aws:iam::770263851087:user/test01"
                },
                {
                    "ResourceType": "AWS::IAM::User",
                    "ResourceName": "test01"
                }
            ],
            "CloudTrailEvent": "{\"eventVersion\":\"1.10\",\"userIdentity\":{\"type\":\"IAMUser\",\"principalId\":\"AIDA3GV2NUBHW2QH6EPN2\",\"arn\":\"arn:aws:iam::770263851087:user/terraform_init\",\"accountId\":\"770263851087\",\"accessKeyId\":\"AKIA3GV2NUBHVYSQM3V2\",\"userName\":\"terraform_init\"},\"eventTime\":\"2025-02-12T18:08:11Z\",\"eventSource\":\"iam.amazonaws.com\",\"eventName\":\"CreateUser\",\"awsRegion\":\"us-east-1\",\"sourceIPAddress\":\"84.108.152.39\",\"userAgent\":\"aws-cli/2.24.1 md/awscrt#0.23.8 ua/2.0 os/linux#6.11.0-14-generic md/arch#x86_64 lang/python#3.12.6 md/pyimpl#CPython cfg/retry-mode#standard md/installer#exe md/distrib#ubuntu.24 md/prompt#off md/command#iam.create-user\",\"requestParameters\":{\"userName\":\"test01\"},\"responseElements\":{\"user\":{\"path\":\"/\",\"userName\":\"test01\",\"userId\":\"AIDA3GV2NUBHSYM5CH6U4\",\"arn\":\"arn:aws:iam::770263851087:user/test01\",\"createDate\":\"Feb 12, 2025 6:08:11 PM\"}},\"requestID\":\"57efcaf6-401a-4c2b-800b-e4b9af66fbeb\",\"eventID\":\"58ac7cc5-42ab-47e1-8998-6e34e488d14f\",\"readOnly\":false,\"eventType\":\"AwsApiCall\",\"managementEvent\":true,\"recipientAccountId\":\"770263851087\",\"eventCategory\":\"Management\",\"tlsDetails\":{\"tlsVersion\":\"TLSv1.3\",\"cipherSuite\":\"TLS_AES_128_GCM_SHA256\",\"clientProvidedHostHeader\":\"iam.amazonaws.com\"}}"
        }' \
    output.txt

aws logs filter-log-events --log-group-name /aws/lambda/ScyllaDB-security-monitor-lambda-function --max-items 10 | jq '.events[] | {timestamp: (.timestamp / 1000 | strftime("%Y-%m-%d %H:%M:%S")), message: .message}'
```
