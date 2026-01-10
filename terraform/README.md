# terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.9 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_lambda"></a> [api\_lambda](#module\_api\_lambda) | ./modules/lambda | n/a |
| <a name="module_process_lambda"></a> [process\_lambda](#module\_process\_lambda) | ./modules/lambda | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_integration.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.query_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_cloudwatch_event_rule.s3_put_object_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.invoke_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.api_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_dynamodb_table.table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.authenticated_user_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eventbridge_invoke_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.api_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.authenticated_user_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eventbridge_invoke_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.process_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.api_lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.api_lambda_dynamodb_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.api_lambda_sns_publish_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.authenticated_user_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eventbridge_invoke_lambda_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.process_lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.process_lambda_dynamodb_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.process_lambda_s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.process_lambda_sns_publish_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_permission.allow_eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.api_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.processing_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.quarantine_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.enable_eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_policy.processing_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.quarantine_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_versioning.processing_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.quarantine_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_sns_topic.alerts_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.alert_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.alert_email_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_iam_policy_document.api_lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eventbridge_invoke_lambda_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.process_lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_user.authenticated_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS account ID where resources will be created | `string` | n/a | yes |
| <a name="input_api_gateway_configuration"></a> [api\_gateway\_configuration](#input\_api\_gateway\_configuration) | Configuration for the API Gateway | <pre>object({<br/>    api_gw_name = optional(string, "eventpulse_api_gateway")<br/>    stage_name  = optional(string, "default")<br/>  })</pre> | `{}` | no |
| <a name="input_api_gw_lambda"></a> [api\_gw\_lambda](#input\_api\_gw\_lambda) | Configuration for the API Gateway Lambda function | <pre>object({<br/>    function_name = optional(string, "eventpulse_api_gw_lambda_function")<br/>    role_name     = optional(string, "eventpulse_api_gw_lambda_function")<br/>    runtime       = optional(string, "python3.12")<br/>  })</pre> | `{}` | no |
| <a name="input_dynamodb_table"></a> [dynamodb\_table](#input\_dynamodb\_table) | Configuration for the DynamoDB table | <pre>object({<br/>    name      = optional(string, "event-pulse-table")<br/>    hash_key  = optional(string)<br/>    range_key = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_iam_authenticated_user_configuration"></a> [iam\_authenticated\_user\_configuration](#input\_iam\_authenticated\_user\_configuration) | The configuration of the authenticated IAM user | <pre>object({<br/>    user_name   = string<br/>    role_name   = optional(string, "eventpulse_authenticated_user_role")<br/>    policy_name = optional(string, "eventpulse_authenticated_user_policy")<br/>  })</pre> | n/a | yes |
| <a name="input_process_json_lambda"></a> [process\_json\_lambda](#input\_process\_json\_lambda) | Configuration for the Process JSON Lambda function | <pre>object({<br/>    function_name = optional(string, "eventpulse_process_json_lambda_function")<br/>    role_name     = optional(string, "eventpulse_process_json_lambda_role")<br/>    runtime       = optional(string, "python3.12")<br/>  })</pre> | `{}` | no |
| <a name="input_processing_bucket"></a> [processing\_bucket](#input\_processing\_bucket) | Configuration for the S3 processing bucket | <pre>object({<br/>    name              = string<br/>    region            = string<br/>    force_destroy     = optional(bool, false)<br/>    versioning_status = optional(string, "Enabled")<br/>  })</pre> | n/a | yes |
| <a name="input_quarantine_bucket"></a> [quarantine\_bucket](#input\_quarantine\_bucket) | Configuration for the S3 quarantine bucket | <pre>object({<br/>    name              = string<br/>    region            = string<br/>    force_destroy     = optional(bool, false)<br/>    versioning_status = optional(string, "Enabled")<br/>  })</pre> | n/a | yes |
| <a name="input_sns_configuration"></a> [sns\_configuration](#input\_sns\_configuration) | Configuration for SNS topics | <pre>object({<br/>    name          = optional(string, "eventpulse_sns_alert_topic")<br/>    email_address = string<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | <pre>{<br/>  "Orchestration": "Terraform",<br/>  "Project": "EventPulse"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_invoke_url"></a> [api\_invoke\_url](#output\_api\_invoke\_url) | The API invoke URL |
| <a name="output_authenticated_user_role_arn"></a> [authenticated\_user\_role\_arn](#output\_authenticated\_user\_role\_arn) | ARN of the IAM role for authenticated user to assume |
| <a name="output_processing_bucket_name"></a> [processing\_bucket\_name](#output\_processing\_bucket\_name) | Name of the S3 processing bucket |
| <a name="output_quarantine_bucket_name"></a> [quarantine\_bucket\_name](#output\_quarantine\_bucket\_name) | Name of the S3 quarantine bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
