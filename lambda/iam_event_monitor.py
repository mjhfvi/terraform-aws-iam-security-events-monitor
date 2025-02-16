import json
import boto3
import os
import logging
from datetime import datetime
from typing import Dict, Any

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_event_details(event: Dict[Any, Any]) -> Dict[str, str]:
    """Extract relevant details from the CloudWatch event."""
    try:
        awslogs = event.get('awslogs', {})
        if awslogs is None:
            logger.error("[DEGUB] No 'awslogs' key found in the event.")
        else:
            logger.info("[DEGUB] Found 'awslogs' key in the event.")

        # Get the detail block from json data
        event_details = event.get('detail', {})

        # Get the events detail
        event_time = event_details.get('eventTime', {})
        event_name = event_details.get('eventName', {})
        event_source = event_details.get('eventSource', {})

        # Get the username (IAM user/role) from events detail
        request_parameters = event_details.get('requestParameters', {})
        user_name = request_parameters.get('userName', {})

        # Get the initiator (IAM user/role) from events detail
        user_identity = event_details.get('userIdentity', {})
        initiated_by = user_identity.get('arn', {})
        
        return {
            'event_time': event_time,
            'event_name': event_name,
            'user_name': user_name,
            'event_source': event_source,
            'initiated_by': initiated_by
        }
    except Exception as error:
        logger.error(f"Error parsing event details: {str(error)}")
        raise

def is_public_ip_range(ip_range: str) -> bool:
    """Check if an IP range is public (non-private)."""
    private_ranges = [
        '10.0.0.0/8',
        '172.16.0.0/12',
        '192.168.0.0/16'    ]
    
    for private_range in private_ranges:
        if ip_range.startswith(private_range.split('/')[0]):
            return False
    return True

def handle_security_group_change(detail: Dict[Any, Any]) -> bool:
    """
    Return True if security group change opens ports to public IP ranges.
    """
    try:
        event_details = detail.get('detail', {})
        request_parameters = event_details.get('requestParameters', {})
        ip_permissions = request_parameters.get('ipPermissions', [])
        
        for permission in ip_permissions:
            ip_ranges = permission.get('ipRanges', [])
            for ip_range in ip_ranges:
                if 'cidrIp' in ip_range and is_public_ip_range(ip_range['cidrIp']):
                    return True
        return False
    except Exception as e:
        logger.error(f"Error checking security group changes: {str(e)}")
        return False

def send_alert(sns_topic_arn: str, message: str) -> None:
    """Send alert notification to SNS topic."""
    try:
        sns = boto3.client('sns')
        sns.publish(
            TopicArn=sns_topic_arn,
            Subject="AWS Security Alert (Lambda Function)",
            Message=message
        )
    except Exception as e:
        logger.error(f"Error sending SNS notification: {str(e)}")
        raise

def lambda_handler(event: Dict[Any, Any], context: Any) -> Dict[str, Any]:
    """Main Lambda handler function."""
    try:
        logger.info(f"Lambda Function triggered with event: {json.dumps(event)}")
        
        # Get SNS topic ARN from environment variable
        sns_topic_arn = os.environ['SNS_TOPIC_ARN']
        
        # Extract event details
        details = get_event_details(event)
        event_name = details['event_name']
        
        # For security group changes, only alert on public IP ranges
        if event_name == 'AuthorizeSecurityGroupIngress':
            if not handle_security_group_change(event['responseElements']):
                logger.info("Security group change does not expose public IP ranges. Skipping alert.")
                return {'statusCode': 200, 'body': 'No alert needed'}
        
        # Construct alert message
        # use for testing, get all the json information:
        # Raw event details: {event}
        message = f"""
    Security Alert: {event_name}
    User Name Created: {details['user_name']}
    Time of Creation: {details['event_time']}
    Initiated By: {details['initiated_by']}
    
    """
        # Send alert to SNS topic
        send_alert(sns_topic_arn, message)
        return {
            'statusCode': 200,
            'body': 'Alert sent successfully'
        }
        
    except Exception as error:
        logger.error(f"Error processing event: {str(error)}")
        return {
            'statusCode': 500,
            'body': f"Error processing event: {str(error)}"
        }

if __name__ == '__main__':
    lambda_handler()
