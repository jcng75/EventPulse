# EventPulse Utilities
This directory contains utility scripts for various tasks related to EventPulse.  These scripts are to be ran from the command line within the `scripts` directory.  It is recommended to use a virtual environment with the required dependencies installed.

## Create Virtual Environment
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## S3 Upload Utility
```python
python3 -m utilities.s3_upload.s3_upload utilities/s3_upload/upload_files/<file_name>.json
```
