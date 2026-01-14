### AWS Account Variables

variable "account_id" {
  description = "The AWS account ID where resources will be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Orchestration = "Terraform"
    Project       = "EventPulse"
  }
}

### S3 Bucket Variables

variable "processing_bucket" {
  type = object({
    name              = string
    region            = string
    force_destroy     = optional(bool, false)
    versioning_status = optional(string, "Enabled")
  })
  description = "Configuration for the S3 processing bucket"

  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.processing_bucket.versioning_status)
    error_message = "versioning_status must be one of 'Enabled', 'Suspended', or 'Disabled'."
  }
}

variable "quarantine_bucket" {
  type = object({
    name              = string
    region            = string
    force_destroy     = optional(bool, false)
    versioning_status = optional(string, "Enabled")
  })
  description = "Configuration for the S3 quarantine bucket"

  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.quarantine_bucket.versioning_status)
    error_message = "versioning_status must be one of 'Enabled', 'Suspended', or 'Disabled'."
  }
}

### DynamoDB Variables

variable "dynamodb_table" {
  type = object({
    name      = optional(string, "event-pulse-table")
    hash_key  = optional(string)
    range_key = optional(string)
  })
  description = "Configuration for the DynamoDB table"
}

### Lambda Variables

variable "process_json_lambda" {
  type = object({
    function_name = optional(string, "eventpulse_process_json_lambda_function")
    role_name     = optional(string, "eventpulse_process_json_lambda_role")
    policy_name   = optional(string, "eventpulse_process_json_lambda_policy")
    runtime       = optional(string, "python3.12")
  })
  description = "Configuration for the Process JSON Lambda function"
  default     = {}
}

variable "api_gw_lambda" {
  type = object({
    function_name = optional(string, "eventpulse_api_gw_lambda_function")
    role_name     = optional(string, "eventpulse_api_gw_lambda_function")
    policy_name   = optional(string, "eventpulse_api_gw_lambda_policy")
    runtime       = optional(string, "python3.12")
  })
  description = "Configuration for the API Gateway Lambda function"
  default     = {}
}

### SNS Variables

variable "sns_configuration" {
  type = object({
    name          = optional(string, "eventpulse_sns_alert_topic")
    email_address = string
  })
  description = "Configuration for SNS topics"
}

### API Gateway Variables

variable "api_gateway_configuration" {
  type = object({
    api_gw_name = optional(string, "eventpulse_api_gateway")
    stage_name  = optional(string, "v1")
  })
  description = "Configuration for the API Gateway"
  default     = {}
}

### IAM Variables

variable "iam_authenticated_user_configuration" {
  description = "The configuration of the authenticated IAM user"
  type = object({
    user_name   = string
    role_name   = optional(string, "eventpulse_authenticated_user_role")
    policy_name = optional(string, "eventpulse_authenticated_user_policy")
  })
}
