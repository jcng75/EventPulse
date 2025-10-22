# terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.14.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.processing_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.quarantine_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.processing_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.quarantine_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_processing_bucket"></a> [processing\_bucket](#input\_processing\_bucket) | Configuration for the S3 processing bucket | <pre>object({<br/>    name              = string<br/>    region            = string<br/>    force_destroy     = optional(bool, false)<br/>    versioning_status = optional(string, "Enabled")<br/>  })</pre> | n/a | yes |
| <a name="input_quarantine_bucket"></a> [quarantine\_bucket](#input\_quarantine\_bucket) | Configuration for the S3 quarantine bucket | <pre>object({<br/>    name              = string<br/>    region            = string<br/>    force_destroy     = optional(bool, false)<br/>    versioning_status = optional(string, "Enabled")<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | <pre>{<br/>  "Orchestration": "Terraform",<br/>  "Project": "EventPulse"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
