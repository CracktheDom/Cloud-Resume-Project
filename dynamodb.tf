# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
# https://docs.aws.amazon.com/dynamodb/index.html
resource "aws_dynamodb_table" "counter_table" {
  name         = "VisitorCounter"
  billing_mode = "PAY_PER_REQUEST"
  # read_capacity  = 20
  # write_capacity = 20
  hash_key = "NumOfVistors"

  attribute {
    name = "NumOfVistors"
    type = "N"
  }

  tags = {
    Name        = "dynamodb-table-counter"
    Environment = "dev"
  }
}

resource "aws_dynamodb_table_item" "counter_item" {
  table_name = aws_dynamodb_table.counter_table.name
  hash_key   = aws_dynamodb_table.counter_table.hash_key
  range_key  = "ItemName"

  item = {
    NumOfVisitors = 1
    ItemName      = "Counter"
  }
}
