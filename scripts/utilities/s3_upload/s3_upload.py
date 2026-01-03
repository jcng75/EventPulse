"""
This utility was created to upload JSON files to the S3 processing bucket.
The script will be a command line utility that can be used like so:
`python s3_upload.py <path_to_json_file>`
"""

import sys
from utilities.reusable.sts_get_credentials import get_credentials
from utilities.reusable.s3_reusable import get_s3_client

def upload_json_to_s3(s3, bucket_name, file_path):
    # Get the file name from the file path (e.g "path/to/file.json" -> "file.json")
    object_key = file_path.split("/")[-1]
    try:
        s3.upload_file(file_path, bucket_name, object_key)
        print(f"Successfully uploaded {file_path} to s3://{bucket_name}/{object_key}")
    except Exception as e:
        print(f"Failed to upload {file_path} to S3: {e}")

def file_exists(file_path):
    try:
        with open(file_path, 'r') as f:
            return True
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return False

def main():
    # Configurations - Run `terraform output` to get the configurations
    bucket_name = "eventpulse-processing-bucket" # Replace with your bucket name

    file_path = sys.argv[1]

    if file_path is None:
        print("Please README.md to identity the proper steps to run the script.")
        return

    if not file_exists(file_path) or not file_path.lower().endswith('.json'):
        print(f"Path {file_path} does produce a JSON file.")
        return

    credentials = get_credentials(iam_role)

    if credentials is None:
        print("Could not assume role, exiting.")
        return

    s3_client = get_s3_client(credentials)

    upload_json_to_s3(s3_client, bucket_name, file_path)

if __name__ == "__main__":
    main()
