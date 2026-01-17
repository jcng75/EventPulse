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
    try:

        ssm_parameter = os.environ.get("API_GATEWAY_SSM")

        # HTTP API authorizers receive headers in lowercase
        headers = event.get('headers', {})
        x_api_key = headers.get('x-api-key') or headers.get('X-Api-Key')

        if not x_api_key:
            print("No API key found in headers")
            return {
                "isAuthorized": False
            }

        ssm_value = get_ssm_parameter(ssm_parameter)

        if not ssm_value:
            print("Failed to retrieve SSM parameter")
            return {
                "isAuthorized": False
            }

        is_valid = x_api_key == ssm_value
        print(f"API key validation result: {is_valid}")

        return {
            "isAuthorized": is_valid
        }

    except Exception as e:
        print(f"Error in lambda_handler: {str(e)}")
        return {
            "isAuthorized": False
        }
