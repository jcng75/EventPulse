"""
This utility was created to assist in removing/checking the objects within the quarantined S3 bucket.
"""

import sys
from ..reusable.sts_get_credentials import get_credentials
from ..reusable.s3_reusable import get_s3_client

import botocore.exceptions

def remove_quarantined_object(s3, bucket_name, object_key):
    in_bucket = check_quarantined_object(s3, bucket_name, object_key)
    if not in_bucket:
        print(f"Discontinuing removal process as object {object_key}.")

    confirmation = input(f"Are you sure you want to remove object {object_key} from bucket {bucket_name}? (yes/no): ")
    if confirmation.lower() != 'yes':
        print("Confirmation not received, stopping removal process.")
    else:
        try:
            s3.delete_object(Bucket=bucket_name, Key=object_key)
            print(f"Successfully removed object {object_key} from bucket {bucket_name}.")
        except Exception as e:
            print(f"Failed to remove object {object_key} from S3: {e}")

def check_quarantined_object(s3, bucket_name, object_key):
    try:
        # Response will go to exceptions if the object does not exist
        response = s3.head_object(Bucket=bucket_name, Key=object_key)
        print(f"Object {object_key} exists in bucket {bucket_name}.")
        return True
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == "404":
            print(f"Object {object_key} does not exist in bucket {bucket_name}.")
            return False
    except Exception as e:
        print(e)
        return False

def main():
    # Configurations - Run `terraform output` to get the configurations
    bucket_name = "eventpulse-quarantine-bucket" # Replace with your quarantine_bucket_name output
    iam_role = "arn:aws:iam::1234567891012:role/eventpulse_authenticated_user_role" # Replace with your authenticated_user_role_arn

    # Should include s3_quarantine_tool, command, and object_key as inputs
    if len(sys.argv) != 3:
        print("Invalid Number of Arguments - Correct Usage: 'python3 -m utilities.s3_quarantine_tool.s3_quarantine_tool <command> <object_key>'")
        return

    command = sys.argv[1].lower()

    if command not in ['remove', 'check']:
        print(f"Invalid Command '{command}' - Supported Commands: 'remove', 'check'")
        return

    object_key = sys.argv[2]

    # Get s3 client with assumed role credentials
    credentials = get_credentials(iam_role)
    s3 = get_s3_client(credentials)


    if command == 'check':
        check_quarantined_object(s3, bucket_name, object_key)
    else: # remove command
        remove_quarantined_object(s3, bucket_name, object_key)


if __name__ == "__main__":
    main()
