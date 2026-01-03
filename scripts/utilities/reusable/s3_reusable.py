# This file contains reusable functions for when necessary between the S3 utilities

import boto3

def get_s3_client(credentials):
    """
    Returns a boto3 S3 client using the provided temporary credentials.
    """
    s3 = boto3.client('s3',
                      aws_access_key_id=credentials['AccessKeyId'],
                      aws_secret_access_key=credentials['SecretAccessKey'],
                      aws_session_token=credentials['SessionToken'])
    return s3
