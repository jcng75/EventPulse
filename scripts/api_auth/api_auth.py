# This Lambda was created to verify API requests being made to the API Gateway.
# It compares the 'x-api-key' header value against a predefined API key stored in SSM parameter store.

import boto3
import json
import os

ssm_client = boto3.client("ssm")

def get_ssm_parameter(parameter_name):
    try:
        response = ssm_client.get_parameter(
            Name=parameter_name,
            WithDecryption=True
        )
        return response['Parameter']['Value']
    except Exception as e:
        print(f"Error retrieving SSM parameter: {e}")
        return None

def lambda_handler(event, context):
    ssm_parameter = os.environ.get("SSM_PARAMETER_NAME")
    x_api_key = event['headers'].get('x-api-key')

    if not x_api_key:
        return {
            "statusCode": 401,
            "body": json.dumps({
                "isAuthorized": False,
                "context": {
                    "message": "Unauthorized: Missing x-api-key header"
                }
                })
        }

    ssm_value = get_ssm_parameter(ssm_parameter)

    if not ssm_value:
        return {
            "statusCode": 500,
            "body": json.dumps({
                "isAuthorized": False,
                "context": {
                    "message": "Internal Server Error: Unable to retrieve API key"
                }
                })
        }

    if x_api_key == ssm_value:
        return {
            "statusCode": 200,
            "body": json.dumps({
                "isAuthorized": True,
                "context": {
                    "message": "Authorized"
                }
                })
        }
    else:
        return {
            "statusCode": 403,
            "body": json.dumps({
                "isAuthorized": False,
                "context": {
                    "message": "Forbidden: Invalid API key"
                }
                })
        }
