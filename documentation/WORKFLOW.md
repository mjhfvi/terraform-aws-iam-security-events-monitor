## discribing the resources flow
- buiding a new user
- cloudtrail logs the event in us-east-1 region (globle region)
- cloudtrail logs the event in other regions (multi region)
- cloudtrail export the events to a s3 bucket
- cloudwatch 'log group' logs the event
- lambda trigger the function based on event filter
- lambda send notification to sns topic