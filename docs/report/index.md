# S5 - Secure Static Simple Storage Service

### Created and Written By - Justin Ng
### Started: September 12, 2025
### Completed: TBD

# Process Documentation

## Initial Improvements
In my previous project [s5](https://github.com/jcng75/s5), I was not satisfied with the way that the backend configuration was setup.  Doing some research, I found that optimizations could be made using a `backend.conf` file.  Shown in the [README.md](../../README.md), the state file can be initialized referencing the created file.  Additionally, I added a `terraform.tfvars` file, allowing values to be customized outside the created terraform code.  Both files are limited to the user, as they were included within the `.gitignore` file.

## Terraform
In addition to the initial improvements, I wanted to change the way I handled the creation of resources.  I believe that various components depended on each other, and that affected the whole development process.  I want to start by creating the components that don't have dependencies first (i.e S3, DynamoDB, etc.).  From there, the components that require them can be build on using them as dependencies.  Additionally, IAM policies should be reconfigured last.  In the beginning, services will be granted access greater than they are needed, but will be adjusted to support the principle of least privilege.  This will improve the speed to begin the foundation of the terraform configurations.

### S3

Initial creation of the buckets was simple to follow.  Using the terraform.tfvars file, I created an object variable for each bucket that needed to be created.  For the `force_destroy` argument, it has been set to default but for the project I configured the value to be **true**.

```
# terraform.tfvars

quarantine_bucket = {
  name = "eventpulse-quarantine-bucket"
  region = "us-east-1"
  force_destroy = true
}

```

One interesting behavior I noticed was when I set the name of both buckets to be the same (i.e eventpulse-processing-bucket).  When running the terraform applies, only **one** of the buckets was created with providing an error.  Updating the quarantine bucket name caused the individual S3 bucket to get replaced.  To fix this problem, I ran `terraform state list` to get the resources and tained both of them.

```
# Confirm the resouces in state
terraform state list
aws_s3_bucket.processing_bucket
aws_s3_bucket.quarantine_bucket

# Taint the resources
terraform taint aws_s3_bucket.processing_bucket
terraform taint aws_s3_bucket.quarantine_bucket

# Rerun the apply
terraform apply
```

After the buckets were created, I added configurations to each bucket.  I first updated the buckets to have configurations for [versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning).  This was done by adding to the variables.  A validation check needed to be added to verify that the string added was a valid argument value.  

From there, an [S3 bucket policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) was created for each bucket.  For this part of the project, security was configured to allow full access for any principals within the AWS account.  This will be revisited later when we focus on hardening security.

### DynamoDB

When starting work on DynamoDB, I learned a lot with how the service worked.  The first thing I needed clarification on was when I tried to standup the [aws_dynamodb_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) resource.  Reading through the documentation, it was a little unclear on how the `hash_key` and `range_key` were used.  Based on my research, the hash key acts as a unique identifier if the range key does not exist.  In other terms, this can be considered the primary key in NoSQL databases.  If the range key **was** included into the table, the hash key **no longer** has to be unique.  One example of this can be having a person ID as the hash key and a `dateCreated` as a range key.

Upon learning this information, it was clear to me that our requirements were not sufficient enough to proceed with the project.  In doing so, I went back to the [index.md](../architecture/index.md) to establish JSON requirements for what users can submit to the S3 bucket.  In this case, we wanted to simulate music data, whether it be a song or album from an artist.  In doing so, this led me to decide the hash_key as `ArtistID` and the sort_key as `ItemID`.  The ItemID had to be unique, so it follows this naming convention:
```
"EntityType#Title"
```
The `EntityType` would be either Track or Album.  For example, the hash key and range key could look like this:
| ArtistID | ItemID |
|:---------|:-------:|
| Knock2 | TRACK#FeelULuvMe |

There are also additional attributes that can be added to the row entry.  In this project, I plan on adding the following attributes:
- Features
- Duration (seconds)
- Streams
- EntityType
- Title

It should be noted that these attributes do NOT need to get added into the terraform resource.  Since DynamoDB is schemaless, only indexes and keys need to be defined.  The rest can vary per item.  This makes sense as we may not need certain attributes like `Features` for a specific song or album.

When discovering this, the logic on attributes needed to be updated.  Since the hash_key is always required but the range_key is not, a conditional was set for both the attribute block and the `range_key` argument.

When running the initial apply, I ran into the following error:

```
│ Error: creating AWS DynamoDB Table (event-pulse-table): replicas: creating replica (us-east-2): operation error DynamoDB: UpdateTable, https response error StatusCode: 400, RequestID: XXXXXXXXXXXXXXXXXXX, api error ValidationException: Table write capacity should either be Pay-Per-Request or AutoScaled.
```

Upon doing further reading, it was explained that autoscaling must be enabled to use provisioned for the `billing_mode`.  This would involve the `aws_appautoscaling_target` resource and defining scaling policies for each target.  To circumvent this, I went with setting the billing mode to `PAY_PER_REQUEST`.  This also led me to removing the capability to add read/write capacity.

`DynamoDB Screenshot Completion:`

<img src="./img/dynamodb-table-creation.jpg" alt="dynamodb-table-creation"/>

To verify that the table was functioning as intended, I ran the following command:
```
aws dynamodb put-item \
  --table-name event-pulse-table \
  --item '{
    "ArtistID": {"S": "Knock2"},
    "ItemID": {"S": "TRACK#FeelULuvMe"},
    "Duration": {"N": "234"},
    "Streams": {"N": "10000000"},
    "EntityType": {"S": "Track"},
    "Title": {"S": "Feel U Luv Me"}
  }'
```
When running this command, it is important to note the --item flag takes in a map as input.  This map must be proper JSON, and takes a **String** as input being converted to a JSON object.  Additionally, each argument inputted must take the attribute as the Key and `{"DATATYPE": "VALUE"}` as the value (see [documentation](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/put-item.html) for more information).  Due to these circumstances, single quotes were used around the map object and double quotes were used within the string.

`DynamoDB Verification Screenshot:`

<img src="./img/dynamodb-query-verification.jpg" alt="dynamodb-table-creation"/>

### JSON Processing (Python)

The next step of the project that I started to work on was the JSON processing lambda script.  Before starting, I wanted to configure the script to be able to test locally.  Boto3 is a required Python3 library for this project.  

Ran the following commands:
```
python3 -m venv .venv
source .venv/bin/activate
pip install boto3
```

The objective of this script was to read from the event, verify the JSON structure, and insert the data into DynamoDB.  If the structure was invalid, the object would be moved to the quarantine bucket.  We first needed to add an object into the S3 processing bucket to simulate the event that would trigger the lambda function.  As a result, `test-object.json` was created within the `scripts/process_json` directory.  The content of the file is as follows:

```
{
  "ArtistID": {
    "S": "ISOKNOCK"
  },
  "ItemID": {
    "S": "TRACK#4EVR"
  },
  "Duration": {
    "N": "195"
  },
  "EntityType": {
    "S": "Track"
  },
  "Streams": {
    "N": "6000000"
  },
  "Title": {
    "S": "4EVR"
  },
  "Features": {
    "L": ["Knock2", "Isoxo"]
  },
  "Year": {
    "N": "2024"
  }
}
```

When building the script, I learned more about the [get_object](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3/client/get_object.html) method from the boto3 S3 client.  The response object returns a `body` attribute that is of type [StreamingBody](https://botocore.amazonaws.com/v1/documentation/api/latest/reference/response.html).  This object has a `read()` method that returns the bytes of the object.  From there, I was able to decode the bytes into a string and load it as a JSON object.

```
python3 process_json.py
INFO:root:Getting object from S3 bucket: eventpulse-processing-bucket, key: test-object.json
INFO:root:{'ArtistID': {'S': 'ISOKNOCK'}, 'ItemID': {'S': 'TRACK#4EVR'}, 'Duration': {'N': '195'}, 'EntityType': {'S': 'Track'}, 'Streams': {'N': '6000000'}, 'Title': {'S': '4EVR'}, 'Features': {'L': ['Knock2', 'Isoxo']}, 'Year': {'N': '2024'}}
```

The next step was to verify the structure of the JSON object.  Based on the requirements, the following attributes are required:
- ArtistID
- ItemID
Additionally, I wanted to make sure that no extraneous attributes were included.  To do this, I created a dictionary that defined the expected attributes and their data types.  The script would iterate through each key in the JSON object and verify that it existed in the expected structure.  If any required attributes were missing, an error would be logged and the object would be marked as invalid.
Finally, the script would check that the data types of each attribute matched the expected types.  Based on how the JSON object is structured, each attribute is a dictionary with a single key representing the data type (e.g., "S" for string, "N" for number, "L" for list).  The script would compare the data type key in the JSON object against the expected type from the structure dictionary.
