resource "aws_cloudwatch_event_rule" "s3_put_object_rule" {
  name        = "s3-put-object-rule"
  description = "Trigger Lambda on S3 PutObject events"
  event_pattern = jsonencode({
    "source" : ["aws.s3"],
    "detail-type" : ["Object Created"],
    "detail" : {
      "bucket" : {
        "name" : [aws_s3_bucket.processing_bucket.id]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.s3_put_object_rule.name
  target_id = "event-pulse-invoke-lambda-target"
  arn       = aws_lambda_function.process_json_lambda.arn
  role_arn  = aws_iam_role.eventbridge_invoke_lambda_role.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_json_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_put_object_rule.arn
}

resource "aws_iam_role" "eventbridge_invoke_lambda_role" {
  name = "eventbridge-invoke-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.account_id
          }
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy_document" "eventbridge_invoke_lambda_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction"
    ]

    resources = [
      aws_lambda_function.process_json_lambda.arn
    ]
  }
}

resource "aws_iam_policy" "eventbridge_invoke_lambda_policy" {
  name   = "event-bridge-eventbridge-invoke-lambda-policy"
  policy = data.aws_iam_policy_document.eventbridge_invoke_lambda_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eventbridge_invoke_lambda_role_policy_attachment" {
  role       = aws_iam_role.eventbridge_invoke_lambda_role.name
  policy_arn = aws_iam_policy.eventbridge_invoke_lambda_policy.arn
}
