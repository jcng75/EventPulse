resource "aws_dynamodb_table" "table" {
  name           = var.dynamodb_table.name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.dynamodb_table.read_capacity
  write_capacity = var.dynamodb_table.write_capacity

  hash_key  = var.dynamodb_table.hash_key
  range_key = var.dynamodb_table.range_key

  attribute {
    name = var.dynamodb_table.hash_key
    type = "S"
  }

  attribute {
    name = var.dynamodb_table.range_key
    type = "S"
  }

  replica {
    region_name = "us-east-2"
  }
}
