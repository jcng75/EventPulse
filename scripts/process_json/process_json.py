# This file is to be used as a lambda function for AWS services.
# The objective of this script was to read from the event, verify the JSON structure, and insert the data into DynamoDB.
# If the structure was invalid, the object would be moved to the quarantine bucket.

import boto3
import os
import json
import logging

dynamodb_client = boto3.client("dynamodb", region_name="us-east-1")
s3_client = boto3.client("s3")

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def get_s3_object(bucket, key):
    logging.info(f"Getting object from S3 bucket: {bucket}, key: {key}")
    response = s3_client.get_object(Bucket=bucket, Key=key)
    content = response['Body'].read().decode('utf-8')
    return json.loads(content)

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
            logging.error(f"Missing required field: {field}")
            is_valid_structure = False

    for key, value in json_object.items():
        # Check if the key is valid in our JSON structure
        if key not in type_checks.keys():
            logging.error(f"Field is not allowed in JSON structure: {key}")
            is_valid_structure = False
            continue
        # Check if the value is the correct type
        dict_keys = value.keys()
        value_to_check = next(iter(dict_keys))
        if type_checks[key] != value_to_check:
            print(f"Checking {key}: expected {type_checks[key]}, got {value_to_check}")
            logging.error(f"Field {key} has incorrect type. Expected {type_checks[key]}, got {value_to_check}")
            is_valid_structure = False

    if is_valid_structure:
        logging.info("JSON structure is valid.")
    else:
        logging.error(f"JSON structure is invalid. - Acceptable fields are: {type_checks.keys()}")

    return is_valid_structure

def lambda_handler(event, context):
    s3_key = event.get("Key", "test-object.json")
    processing_bucket = event.get("Bucket", "eventpulse-processing-bucket")

    dynamodb_table = os.environ.get("DYNAMODB_TABLE", "event-pulse-table")
    quarantine_bucket = os.environ.get("QUARANTINE_BUCKET", "eventpulse-quarantine-bucket")

    json_object = get_s3_object(processing_bucket, s3_key)
    validate_json_structure(json_object)
    pass

if __name__ == "__main__":
    test_event = {
        "Key": "test-object.json",
        "Bucket": "eventpulse-processing-bucket"
    }
    lambda_handler(test_event, None)
