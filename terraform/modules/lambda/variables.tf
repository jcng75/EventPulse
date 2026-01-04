variable "iam_role" {
  type        = string
  description = "The IAM role ARN that the Lambda function will assume"
}

variable "environment_variables" {
  description = "A map of environment variables to set for the Lambda functions"
  type        = map(string)
  default     = {}
}

variable "lambda_handler" {
  type        = string
  description = "The function within your code that Lambda calls to begin execution"
}

variable "archive_file_configuration" {
  description = "Configuration for the archive_file data source"
  type = object({
    type        = optional(string, "zip")
    source_file = string
    output_path = string
  })
}

variable "lambda_function_name" {
  type        = string
  description = "The name of the Lambda function"
}

variable "lambda_runtime" {
  type        = string
  description = "The runtime environment for the Lambda function"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Orchestration = "Terraform"
    Project       = "EventPulse"
  }
}
