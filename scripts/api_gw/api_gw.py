# This file is to be used as a lambda function for AWS API Gateway.

import boto3
import os
import json

def lambda_handler(event, context):

    dynamodb_table = os.environ.get("DYNAMODB_TABLE", "event-pulse-table")
    sns_topic_arn = os.environ.get("SNS_TOPIC_ARN", None)

    return {"statusCode": 200, "body": "API Gateway Lambda Ran Successfully."}
