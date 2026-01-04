moved {
  from = aws_iam_role_policy_attachment.sns_publish_access
  to   = aws_iam_role_policy_attachment.process_lambda_sns_publish_access
}

moved {
  from = aws_iam_role_policy_attachment.s3_access
  to   = aws_iam_role_policy_attachment.process_lambda_s3_access
}

moved {
  from = aws_iam_role_policy_attachment.dynamodb_access
  to   = aws_iam_role_policy_attachment.process_lambda_dynamodb_access
}


moved {
  from = aws_iam_role_policy_attachment.lambda_basic_execution
  to   = aws_iam_role_policy_attachment.process_lambda_basic_execution
}

moved {
  from = aws_iam_role.lambda_role
  to   = aws_iam_role.process_lambda_role
}
