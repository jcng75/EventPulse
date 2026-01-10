# IAM Role ARN for authenticated user
output "authenticated_user_role_arn" {
  description = "ARN of the IAM role for authenticated user to assume"
  value       = aws_iam_role.authenticated_user_role.arn
}

# S3 Bucket Names
output "processing_bucket_name" {
  description = "Name of the S3 processing bucket"
  value       = aws_s3_bucket.processing_bucket.bucket
}

output "quarantine_bucket_name" {
  description = "Name of the S3 quarantine bucket"
  value       = aws_s3_bucket.quarantine_bucket.bucket
}

output "api_invoke_url" {
  description = "The API invoke URL"
  value       = aws_apigatewayv2_api.lambda.api_endpoint
}
