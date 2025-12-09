# IAM role for Lambda execution
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = var.process_json_lambda.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dynamodb_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Package the Lambda function code
data "archive_file" "process_json" {
  type        = "zip"
  source_file = "${path.module}/../scripts/process_json/process_json.py"
  output_path = "${path.module}/lambda/process_json.zip"
}

# Lambda function
resource "aws_lambda_function" "process_json_lambda" {
  filename         = data.archive_file.process_json.output_path
  function_name    = var.process_json_lambda.function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "process_json.lambda_handler"
  source_code_hash = data.archive_file.process_json.output_base64sha256

  runtime = var.process_json_lambda.runtime

  lifecycle {
    replace_triggered_by = [null_resource.replace_function]
  }

  environment {
    variables = {
      DYNAMODB_TABLE    = var.dynamodb_table.name
      QUARANTINE_BUCKET = var.quarantine_bucket.name
    }
  }

  tags = var.tags
}

resource "null_resource" "replace_function" {
  triggers = {
    filehash = data.archive_file.process_json.output_base64sha256
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.process_json_lambda.function_name}"
  retention_in_days = 14
  tags              = var.tags
}
