# This script was created to make API queries with the API Gateway created.

import boto3
import requests
import json
import click

from ..reusable.sts_get_credentials import get_credentials

def make_api_query(endpoint, params=None, headers=None):
    """Make a GET request to the API endpoint."""
    try:
        response = requests.get(endpoint, params=params, headers=headers)
        return response.json()
    except Exception as e:
        print(f"Error making API request: {e}")
        return None

@click.command()
@click.option("--artist_id", required=True, help="Artist ID to filter the API query.")
@click.option("--item_id", default=None, help="Item ID to used to filter the API query.")
@click.option("--attributes", default=None, help="Attributes to filter the response of the API query (comma-separated).")
def main(artist_id, item_id, attributes):
    """Query the EventPulse API Gateway."""

    # Configurations - Run `terraform output` to get the configurations
    invoke_url = "https://jz7eq1qnk8.execute-api.us-east-1.amazonaws.com/v1/items" # `api_invoke_url` value
    ssm_parameter = "/eventpulse/api_gateway/api_key" # `ssm_api_key_parameter_name` value
    iam_role = "arn:aws:iam::1234567891012:role/eventpulse_authenticated_user_role" # Replace with your IAM role ARN

    credentials = get_credentials(iam_role)


    if credentials is None:
        print("Could not assume role, exiting.")
        return

    ssm_client = boto3.client("ssm",
                              aws_access_key_id=credentials['AccessKeyId'],
                              aws_secret_access_key=credentials['SecretAccessKey'],
                              aws_session_token=credentials['SessionToken'],
                              region_name="us-east-1")

    ssm_parameter_value = None

    try:
        response = ssm_client.get_parameter(
            Name=ssm_parameter,
            WithDecryption=True
        )
        ssm_parameter_value = response['Parameter']['Value']
    except Exception as e:
        print(f"Error retrieving SSM parameter: {e}")
        return

    # Build query parameters
    params = {"artist_id": artist_id}

    if item_id:
        params["item_id"] = item_id

    if attributes:
        params["attributes"] = attributes

    print(f"Querying API with params: {params}")

    headers = {"x-api-key": ssm_parameter_value}

    response = make_api_query(invoke_url, params=params, headers=headers)

    if response:
        print("\nAPI Response:")
        print(json.dumps(response, indent=2))
    else:
        print("Failed to get response from API.")

if __name__ == "__main__":
    main()
