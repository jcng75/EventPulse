resource "aws_sns_topic" "alerts_topic" {
  name = var.sns_configuration.name
  tags = merge({
    Name = var.sns_configuration.name
  }, var.tags)
}

resource "aws_sns_topic_subscription" "alert_email_subscription" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "email"
  endpoint  = var.sns_configuration.email_address
}

# ALlow Lambda functions to publish to the SNS topic
resource "aws_sns_topic_policy" "alert_topic_policy" {
  arn = aws_sns_topic.alerts_topic.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["lambda.amazonaws.com"]
        }
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.alerts_topic.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.account_id
          }
        }
      }
    ]
  })
}
