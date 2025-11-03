resource "aws_dynamodb_table" "table" {
  name           = var.dynamodb_table.name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.dynamodb_table.read_capacity
  write_capacity = var.dynamodb_table.write_capacity

  hash_key = var.dynamodb_table.hash_key
  # Only create range_key attribute if range_key is provided
  range_key = var.dynamodb_table.range_key != null ? var.dynamodb_table.range_key : null

  attribute {
    name = var.dynamodb_table.hash_key
    type = "S"
  }

  # Only create range_key attribute if range_key is provided
  dynamic "attribute" {
    for_each = var.dynamodb_table.range_key != null ? [var.dynamodb_table.range_key] : []
    content {
      name = attribute.value
      type = "S"
    }
  }

  replica {
    region_name = "us-east-2"
  }
}
