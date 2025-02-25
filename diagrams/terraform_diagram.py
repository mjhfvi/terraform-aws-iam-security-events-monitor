from __future__ import annotations

from diagrams import Cluster
from diagrams import Diagram
from diagrams.aws.compute import Lambda
from diagrams.aws.compute import LambdaFunction
from diagrams.aws.engagement import SimpleEmailServiceSesEmail
from diagrams.aws.general import MobileClient
from diagrams.aws.general import User
from diagrams.aws.general import Users
from diagrams.aws.integration import SimpleNotificationServiceSnsEmailNotification
from diagrams.aws.integration import SNS
from diagrams.aws.management import Cloudtrail
from diagrams.aws.management import Cloudwatch
from diagrams.aws.mobile import Mobile
from diagrams.aws.security import IAM
from diagrams.aws.security import IAMRole
from diagrams.aws.storage import ElasticFileSystemEFS
from diagrams.aws.storage import S3
from diagrams.aws.storage import SimpleStorageServiceS3Bucket

graph_attr = {
    'fontsize': '45',
    # "bgcolor": "transparent"
}


# direction values are: TB, BT, LR, and RL
def create_infrastructure_diagram():
    with Diagram('IAM Security Alerts Infrastructure', filename='terraform_diagram', graph_attr=graph_attr, direction='LR', outformat='png', show=False):

        # Access Management Cluster
        # with Cluster("Access Management"):
        # iam_policy = IAMRole("IAM Policy")
        iam_user = User('Create IAM User')

        # Storage Cluster
        with Cluster('Events Logs'):
            cloudtrail_logs = Cloudtrail('Cloudtrail Logs')
            cloudwatch_logs = Cloudwatch('Cloudwatch - IAM Logs')

            with Cluster('Storage'):
                s3_bucket = SimpleStorageServiceS3Bucket(
                    'Bucket - Cloudtrail Logs')

        # Compute Cluster
        with Cluster('Lambda Function'):
            # aws_lambda = Lambda("Lambda")
            lambda_function = LambdaFunction('IAM Events Logs')

        # SNS Resources
        with Cluster('SNS Topics'):
            sns_topic = SNS('IAM Security Alerts')
            sns_email_notification = SimpleEmailServiceSesEmail(
                'Email Notification')
            sns_sms_notification = Mobile('SMS Notification')

        # Define the flow of resources
        iam_user >> cloudtrail_logs << s3_bucket
        cloudtrail_logs >> cloudwatch_logs >> lambda_function >> sns_topic >> [
            sns_email_notification, sns_sms_notification]


if __name__ == '__main__':
    create_infrastructure_diagram()
