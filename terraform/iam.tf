# This file defines the IAM roles and policies for the authenticated IAM user

data "aws_iam_user" "authenticated_user" {
  user_name = var.iam_authenticated_user_configuration.user_name
}

resource "aws_iam_role" "authenticated_user_role" {
  name = var.iam_authenticated_user_configuration.role_name
  tags = var.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_iam_user.authenticated_user.arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Allow the authenticated user to access the S3 buckets
resource "aws_iam_policy" "authenticated_user_policy" {
  name = var.iam_authenticated_user_configuration.policy_name
  tags = var.tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
        ]
        Resource = [
          aws_s3_bucket.processing_bucket.arn,
          "${aws_s3_bucket.processing_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.quarantine_bucket.arn,
          "${aws_s3_bucket.quarantine_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "authenticated_user_role_attachment" {
  role       = aws_iam_role.authenticated_user_role.name
  policy_arn = aws_iam_policy.authenticated_user_policy.arn
}
