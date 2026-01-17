# This file is to be used as a lambda function for AWS API Gateway.

import boto3
import os
import json

dynamodb_client = boto3.client("dynamodb")

def make_query(dynamodb_table, artist_id, item_id=None, attributes=None):
    try:
        ExpressionAttributeValues = {
            ":artist_id": {"S": artist_id}
        }

        # Add item_id to the expression if not null
        if item_id:
            ExpressionAttributeValues[":item_id"] = {"S": item_id}

        query = {
            "TableName": dynamodb_table,
            "Select": "ALL_ATTRIBUTES",
            "KeyConditionExpression": "ArtistID = :artist_id" + (" AND ItemID = :item_id" if item_id else ""),
            "ExpressionAttributeValues": ExpressionAttributeValues,
            "Limit": 50
        }

        response = dynamodb_client.query(**query)

        if response["Count"] < 1:
            return {"message": "No items found"}
        elif not attributes:
            return response["Items"]

        post_filtered_items = response["Items"]
        # Filter attributes if specified
        for item in post_filtered_items:
            keys_to_remove = [key for key in item.keys() if key not in attributes]
            for key in keys_to_remove:
                item.pop(key)

        return post_filtered_items

    except Exception as e:
        return {"error": str(e)}

def lambda_handler(event, context):
    try:

        dynamodb_table = os.environ.get("DYNAMODB_TABLE", "event-pulse-table")
        query_params = event.get("queryStringParameters", {})

        artist_id = query_params.get("artist_id", None)
        item_id = query_params.get("item_id", None)

        attributes_str = query_params.get("attributes", None)
        attributes = None
        if attributes_str:
            attributes = attributes_str.split(",")

        if not artist_id:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "artist_id is required"}),
                "headers": {"Content-Type": "application/json"}
            }

        response = make_query(dynamodb_table=dynamodb_table, artist_id=artist_id, attributes=attributes, item_id=item_id)

        return {
            "statusCode": 200,
            "body": json.dumps(response, default=str),
            "headers": {"Content-Type": "application/json"}
        }

    except Exception as e:
        print(f"Error in lambda_handler: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
            "headers": {"Content-Type": "application/json"}
        }
