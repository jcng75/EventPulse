"""
This utility was created to upload JSON files to the S3 processing bucket.
The script will be a command line utility that can be used like so:
`python s3_upload.py <path_to_json_file>`
"""

import boto3
import sys

s3_client = boto3.client("s3")

def upload_json_to_s3(bucket_name, file_path):
    # Get the file name from the file path (e.g "path/to/file.json" -> "file.json")
    object_key = file_path.split("/")[-1]
    try:
        s3_client.upload_file(file_path, bucket_name, object_key)
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
    # Configurations
    bucket_name = "eventpulse-processing-bucket" # Replace with your bucket name
    file_path = sys.argv[1]

    if file_path is None:
        print("Please use the following format to run the script: python s3_upload.py <path_to_json_file>")
        return

    if not file_exists(file_path) or not file_path.endswith('.json'):
        print(f"Path {file_path} does produce a JSON file.")
        return

    upload_json_to_s3(bucket_name, file_path)

if __name__ == "__main__":
    main()
