moved {
  from = data.archive_file.process_json
  to   = module.process_lambda.data.archive_file.archive
}

moved {
  from = aws_lambda_function.process_json_lambda
  to   = module.process_lambda.aws_lambda_function.function
}

moved {
  from = aws_cloudwatch_log_group.lambda_log_group
  to   = module.process_lambda.aws_cloudwatch_log_group.lambda_log_group
}

moved {
  from = null_resource.replace_function
  to   = module.process_lambda.null_resource.replace_function
}
