resource "aws_dynamodb_table" "this" {
  name         = local.namespaced_service_name
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "new_todo" {
  hash_key   = aws_dynamodb_table.this.hash_key
  table_name = aws_dynamodb_table.this.name

  item = <<EOF
{
  "id": {"N": "1"},
  "task": {"S": "Testing tasks"},
  "done": {"S": "false"}
}
EOF
}
