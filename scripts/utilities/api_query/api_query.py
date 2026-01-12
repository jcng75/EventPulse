# This script was created to make API queries with the API Gateway created.

import requests
import json
import click

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
    # Replace the value of the invoke URL by running `terraform output` and copying the value of `api_invoke_url`
    invoke_url = "https://jz7eq1qnk8.execute-api.us-east-1.amazonaws.com/v1/items"

    # Build query parameters
    params = {"artist_id": artist_id}

    if item_id:
        params["item_id"] = item_id

    if attributes:
        params["attributes"] = attributes

    print(f"Querying API with params: {params}")

    response = make_api_query(invoke_url, params=params)

    if response:
        print("\nAPI Response:")
        print(json.dumps(response, indent=2))
    else:
        print("Failed to get response from API.")

if __name__ == "__main__":
    main()
