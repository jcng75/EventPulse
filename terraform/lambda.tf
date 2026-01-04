## Process JSON Lambda Function

# IAM role for Lambda execution
data "aws_iam_policy_document" "process_lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "process_lambda_role" {
  name               = var.process_json_lambda.role_name
  assume_role_policy = data.aws_iam_policy_document.process_lambda_assume_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "process_lambda_basic_execution" {
  role       = aws_iam_role.process_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "process_lambda_dynamodb_access" {
  role       = aws_iam_role.process_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "process_lambda_s3_access" {
  role       = aws_iam_role.process_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "process_lambda_sns_publish_access" {
  role       = aws_iam_role.process_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

module "process_lambda" {
  source = "./modules/lambda"

  iam_role             = aws_iam_role.process_lambda_role.arn
  lambda_handler       = "process_json.lambda_handler"
  lambda_runtime       = var.process_json_lambda.runtime
  lambda_function_name = var.process_json_lambda.function_name
  archive_file_configuration = {
    source_file = "${path.module}/../scripts/process_json/process_json.py"
    output_path = "${path.module}/lambda/process_json.zip"
  }
  environment_variables = {
    DYNAMODB_TABLE    = aws_dynamodb_table.table.name
    QUARANTINE_BUCKET = aws_s3_bucket.quarantine_bucket.bucket
    SNS_TOPIC_ARN     = aws_sns_topic.alerts_topic.arn
  }
  tags = var.tags
}

## API Gateway Lambda Function
