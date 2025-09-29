# EventPulse
An event-based serverless architecture project tasked with processing and parsing JSON files reliably and quickly.

### Created and Written By - Justin Ng
### Started: September 12, 2025
### Completed: TBD

Credit to Tech with Soleyman for the project idea!

**Prerequisites**:

- AWS Account
- Access Credentials
- Terraform
- WSL2 (Preferred)

**Installation Guides(s)**:

*Terraform* - https://linuxbeast.com/blog/how-to-configure-terraform-on-windows-10-wsl-ubuntu-for-aws-provisioning/

*AWS* - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

*AWS CLI Configuration* - https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-files.html

After cloning the repository, please update the `terraform/` subdirectory with the following files:

***backend.conf***
```
bucket = "example-terraform-state-bucket" # S3 Bucket storing state file
key = "EventPulse/terraform.tfstate" # Key Object Name Stored in S3 Bucket
dynamodb_table = "example-terraform-state-lock-table" # DynamoDB table managing locks
```

***terraform.tfvars*** - All terraform variables should be populated here.
```
example_variable = "example_value"
```

When properly configured, run `terraform init -backend-config=backend.conf` to initialize the state file into the S3 bucket.
