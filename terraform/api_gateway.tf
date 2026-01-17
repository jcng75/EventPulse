resource "aws_apigatewayv2_api" "lambda" {
  name          = var.api_gateway_configuration.api_gw_name
  protocol_type = "HTTP"
  tags          = var.tags
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = var.api_gateway_configuration.stage_name
  auto_deploy = true

  # Send logs to CloudWatch
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }

  tags = var.tags
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = module.api_lambda.lambda_invoke_url
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "query_table" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.api_key_authorizer.id
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 14
  tags              = var.tags
}

# Allow API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.api_lambda.lambda_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

# Allow API Gateway to invoke the authorizer Lambda
resource "aws_lambda_permission" "authorizer" {
  statement_id  = "AllowExecutionFromAPIGatewayAuthorizer"
  action        = "lambda:InvokeFunction"
  function_name = module.api_auth_lambda.lambda_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/authorizers/${aws_apigatewayv2_authorizer.api_key_authorizer.id}"
}

resource "aws_api_gateway_api_key" "api_key" {
  name        = var.api_gateway_configuration.api_key_name
  description = "API Key for accessing the API Gateway"
  enabled     = true
  tags        = var.tags
}

# Store API Key in SSM Parameter Store
resource "aws_ssm_parameter" "api_key_parameter" {
  name        = "/eventpulse/api_gateway/api_key"
  description = "API Key for EventPulse API Gateway"
  type        = "SecureString"
  value       = aws_api_gateway_api_key.api_key.value
  tags        = var.tags
}

resource "aws_apigatewayv2_authorizer" "api_key_authorizer" {
  api_id                            = aws_apigatewayv2_api.lambda.id
  authorizer_type                   = "REQUEST"
  authorizer_payload_format_version = "2.0"
  authorizer_uri                    = module.api_auth_lambda.lambda_invoke_url
  identity_sources                  = ["$request.header.x-api-key"]
  name                              = "api-key-authorizer"
}
