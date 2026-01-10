output "lambda_arn" {
  description = "The lambda function ARN"
  value       = aws_lambda_function.function.arn
}

output "lambda_name" {
  description = "The lambda function name"
  value       = aws_lambda_function.function.function_name
}

output "lambda_invoke_url" {
  description = "The lambda function invoke URL"
  value       = aws_lambda_function.function.invoke_arn
}
