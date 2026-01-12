# EventPulse Utilities
This directory contains utility scripts for various tasks related to EventPulse.  These scripts are to be ran from the command line within the `scripts` directory.  It is recommended to use a virtual environment with the required dependencies installed.

**NOTE: Before running any scripts, ensure that you have the necessary AWS credentials and permissions configured in your environment.  Additionally, update the configurations within the main() functions of each utility script as necessary.**

## Create Virtual Environment
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## S3 Upload Utility
This utility script uploads files to an S3 bucket using specified IAM role credentials.  Ensure that the configuration within the script is updated with the correct bucket name and IAM role ARN before running.

### Usage
```bash
python3 -m utilities.s3_upload.s3_upload utilities/s3_upload/upload_files/<file_name>.json
```

## S3 Quarantine Tool
This utility script manages quarantined objects in an S3 bucket.  It supports commands to list and delete quarantined objects.  Ensure that the configuration within the script is updated with the correct bucket name and IAM role ARN before running.

### Usage
```bash
python3 -m utilities.s3_quarantine_tool.s3_quarantine_tool <command> <object_key>
```
### Commands
- `check`: Check if a specific object is quarantined.
- `remove`: Remove a specific quarantined object.

## API Query Tool
This utility script makes GET requests to an API Gateway endpoint with specified parameters.  Ensure that the configuration within the script is updated with the correct endpoint URL before running.

### Usage
```bash
python3 -m utilities.api_query.api_query --artist-id <artist_id> --attributes "<attributes>" --item_id <item_id>
```

**NOTE:** The `--attributes` parameter should be a comma-separated list of attributes.
