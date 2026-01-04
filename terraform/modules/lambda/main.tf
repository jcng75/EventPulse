# Package the Lambda function code
data "archive_file" "archive" {
  type        = var.archive_file_configuration.type
  source_file = var.archive_file_configuration.source_file
  output_path = var.archive_file_configuration.output_path
}

# Lambda function
resource "aws_lambda_function" "function" {
  filename         = data.archive_file.archive.output_path
  function_name    = var.lambda_function_name
  role             = var.iam_role
  handler          = var.lambda_handler
  source_code_hash = data.archive_file.archive.output_base64sha256

  runtime = var.lambda_runtime

  lifecycle {
    replace_triggered_by = [null_resource.replace_function]
  }

  environment {
    variables = var.environment_variables
  }

  tags = var.tags
}

resource "null_resource" "replace_function" {
  triggers = {
    filehash = data.archive_file.archive.output_base64sha256
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.function.function_name}"
  retention_in_days = 14
  tags              = var.tags
}
