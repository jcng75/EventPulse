# EventPulse
An event-based serverless architecture project tasked with processing and parsing JSON files reliably and quickly.

### Created and Written By - Justin Ng
### Started: September 12, 2025
### v1 Completed: January 12, 2026
### Optimizations: Presently Ongoing

Credit to Tech with Soleyman for the project idea!

**Prerequisites**:

- AWS Account
- Access Credentials
- Terraform
- WSL2 (Preferred)
- API Testing Tool (Postman, Insomnia, etc.)

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
account_id = "1234567891012" # Your AWS Account ID

processing_bucket = {
  name          = "eventpulse-processing-bucket"
  region        = "us-east-1"
  force_destroy = true
}

quarantine_bucket = {
  name          = "eventpulse-quarantine-bucket"
  region        = "us-east-1"
  force_destroy = true
}

dynamodb_table = {
  name      = "event-pulse-table"
  hash_key  = "ArtistID"
  range_key = "ItemID"
}

sns_configuration = {
  name          = "eventpulse_sns_alert_topic"
  email_address = "justinchunng@gmail.com" # Your email for SNS alerts
}

iam_authenticated_user_configuration = {
  user_name = "user" # Your IAM user name
}

```

When properly configured, run `terraform init -backend-config=backend.conf` to initialize the state file into the S3 bucket.  Then run `terraform apply` to provision the resources.

# EventPulse Utilities
Please reference the `scripts/README.md` file for utility scripts related to EventPulse.

Don't hesitate to share any feedback or concerns about the project using the contact information provided below. Also, if there's anything else you'd like to discuss, feel free to reach out!

[Email](mailto:justinchunng@gmail.com) <br>
[LinkedIn](https://www.linkedin.com/in/justinchunng/) <br>
[GitHub](https://github.com/jcng75)
