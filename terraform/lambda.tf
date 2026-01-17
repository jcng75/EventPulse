## Process JSON Lambda Function

# IAM Role for Process JSON Lambda
data "aws_iam_policy_document" "process_lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
  }
}

resource "aws_iam_role" "process_lambda_role" {
  name               = var.process_json_lambda.role_name
  assume_role_policy = data.aws_iam_policy_document.process_lambda_assume_role.json
  tags               = var.tags
}

resource "aws_iam_policy" "process_lambda_policy" {
  name        = var.process_json_lambda.policy_name
  description = "Policy for Process JSON Lambda with least privilege"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem"
        ]
        Resource = aws_dynamodb_table.table.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.processing_bucket.arn,
          "${aws_s3_bucket.processing_bucket.arn}/*",
          aws_s3_bucket.quarantine_bucket.arn,
          "${aws_s3_bucket.quarantine_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.alerts_topic.arn
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "process_lambda_basic_execution" {
  role       = aws_iam_role.process_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "process_lambda_role_attachment" {
  role       = aws_iam_role.process_lambda_role.name
  policy_arn = aws_iam_policy.process_lambda_policy.arn
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

data "aws_iam_policy_document" "api_lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
  }
}

resource "aws_iam_role" "api_lambda_role" {
  name               = var.api_gw_lambda.role_name
  assume_role_policy = data.aws_iam_policy_document.api_lambda_assume_role.json
  tags               = var.tags
}

resource "aws_iam_policy" "api_lambda_policy" {
  name        = var.api_gw_lambda.policy_name
  description = "Policy for API GW Lambda with least privilege"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query"
        ]
        Resource = [aws_dynamodb_table.table.arn,
          "${aws_dynamodb_table.table.arn}/*"
        ]
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "api_lambda_basic_execution" {
  role       = aws_iam_role.api_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "api_lambda_role_attachment" {
  role       = aws_iam_role.api_lambda_role.name
  policy_arn = aws_iam_policy.api_lambda_policy.arn
}

module "api_lambda" {
  source = "./modules/lambda"

  iam_role             = aws_iam_role.api_lambda_role.arn
  lambda_handler       = "api_gw.lambda_handler"
  lambda_runtime       = var.api_gw_lambda.runtime
  lambda_function_name = var.api_gw_lambda.function_name
  archive_file_configuration = {
    source_file = "${path.module}/../scripts/api_gw/api_gw.py"
    output_path = "${path.module}/lambda/api_gw.zip"
  }
  environment_variables = {
    DYNAMODB_TABLE = aws_dynamodb_table.table.name
    SNS_TOPIC_ARN  = aws_sns_topic.alerts_topic.arn
  }
  tags = var.tags
}
