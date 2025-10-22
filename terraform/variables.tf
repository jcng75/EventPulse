variable "processing_bucket" {
  type = object({
    name          = string
    region        = string
    force_destroy = optional(bool, false)
  })
  description = "Configuration for the S3 processing bucket"
}

variable "quarantine_bucket" {
  type = object({
    name          = string
    region        = string
    force_destroy = optional(bool, false)
  })
  description = "Configuration for the S3 quarantine bucket"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Orchestration = "Terraform"
    Project       = "EventPulse"
  }
}
