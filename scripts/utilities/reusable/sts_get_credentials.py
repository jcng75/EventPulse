# This file creates a reusable function to get IAM role credentials using STS.

import boto3

sts_client = boto3.client('sts')

# Ref: https://docs.aws.amazon.com/code-library/latest/ug/python_3_sts_code_examples.html
def get_credentials(role_arn, session_name="AssumeRoleSession"):
    try:
        response = sts_client.assume_role(
            RoleArn=role_arn,
            RoleSessionName=session_name
        )
        return response['Credentials']
    except Exception as e:
        print(f"Error assuming role {role_arn}: {e}")
        return None
