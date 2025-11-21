# This file is to be used as a lambda function for AWS services.
# The objective of this script was to read from the event, verify the JSON structure, and insert the data into DynamoDB.
# If the structure was invalid, the object would be moved to the quarantine bucket.

import boto3
import os
import json
import botocore

dynamodb_client = boto3.client("dynamodb", region_name="us-east-1")
s3_client = boto3.client("s3")

def get_s3_object(bucket, key):
    print(f"Getting object from S3 bucket: {bucket}, key: {key}")
    response = s3_client.get_object(Bucket=bucket, Key=key)
    content = response['Body'].read().decode('utf-8')
    return json.loads(content)

def in_quarantine(s3_key, quarantine_bucket):
    print(f"Checking if object {s3_key} is in quarantine bucket: {quarantine_bucket}")
    try:
        s3_client.head_object(Bucket=quarantine_bucket, Key=s3_key)
        print("Object found in quarantine.")
        return True
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] in ("404", "NoSuchKey"):
            print("Object not found in quarantine.")
            return False
        else:
            print(f"Error checking quarantine: {e}")
            return False

def move_to_quarantine(processing_bucket, quarantine_bucket, s3_key):
    print(f"Moving object {s3_key} from {processing_bucket} to {quarantine_bucket}")
    s3_client.copy_object(
        Bucket=quarantine_bucket,
        CopySource={'Bucket': processing_bucket, 'Key': s3_key},
        Key=s3_key
    )
    s3_client.delete_object(Bucket=processing_bucket, Key=s3_key)
    print("Object moved to quarantine successfully.")

def validate_json_structure(json_object):
    type_checks = {
        "ArtistID": "S",
        "ItemID": "S",
        "Title": "S",
        "EntityType": "S",
        "Duration": "N",
        "Streams": "N",
        "Year": "N",
        "Features": "L"
    }
    required_fields = ["ArtistID", "ItemID"]

    is_valid_structure = True

    for field in required_fields:
        if field not in json_object:
            print(f"Missing required field: {field}")
            is_valid_structure = False

    for key, value in json_object.items():
        # Check if the key is valid in our JSON structure
        if key not in type_checks.keys():
            print(f"Field is not allowed in JSON structure: {key}")
            is_valid_structure = False
            continue
        # Check if the value is the correct type
        dict_keys = value.keys()
        value_to_check = next(iter(dict_keys))
        if type_checks[key] != value_to_check:
            print(f"Checking {key}: expected {type_checks[key]}, got {value_to_check}")
            print(f"Field {key} has incorrect type. Expected {type_checks[key]}, got {value_to_check}")
            is_valid_structure = False

    if is_valid_structure:
        print("JSON structure is valid.")
    else:
        print(f"JSON structure is invalid. - Acceptable fields are: {type_checks.keys()}")

    return is_valid_structure

def insert_into_dynamodb(table_name, json_object):
    print(f"Inserting item into DynamoDB table: {table_name}")
    print(json_object.items())
    dynamodb_client.put_item(
        TableName=table_name,
        Item={k: v for k, v in json_object.items()}
    )
    print("Item inserted successfully into DynamoDB.")

def lambda_handler(event, context):
    event_details = event["detail"]
    s3_key = event_details["object"]["key"]
    processing_bucket = event_details["bucket"]["name"]

    dynamodb_table = os.environ.get("DYNAMODB_TABLE", "event-pulse-table")
    quarantine_bucket = os.environ.get("QUARANTINE_BUCKET", "eventpulse-quarantine-bucket")

    if in_quarantine(s3_key, quarantine_bucket):
        print("Object is already in quarantine. Exiting processing.")
        return {"statusCode": 200, "body": "Object is already in quarantine."}

    json_object = get_s3_object(processing_bucket, s3_key)
    is_valid = validate_json_structure(json_object)

    if not is_valid:
        move_to_quarantine(processing_bucket, quarantine_bucket, s3_key)
        return
    else:
        insert_into_dynamodb(dynamodb_table, json_object)

    return {"statusCode": 200, "body": "Processing completed successfully."}
