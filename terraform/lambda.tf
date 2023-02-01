data "archive_file" "shared_layer" {
  output_path = "files/shared-layer.zip"
  type        = "zip"
  source_dir  = "${local.layer_path}/shared"
}

resource "aws_lambda_layer_version" "shared" {
  layer_name       = "shared-layer"
  description      = "Shared layer for functions"
  filename         = data.archive_file.shared_layer.output_path
  source_code_hash = data.archive_file.shared_layer.output_base64sha256
}

data "archive_file" "todos" {
  for_each = local.lambdas

  output_path = "files/${each.key}-todo-artifact.zip"
  type        = "zip"
  source_file = "${local.lambdas_path}/${each.key}.py"
}

resource "aws_lambda_function" "todos" {
  for_each = local.lambdas

  function_name = "dynamodb-${each.key}-item"
  handler       = "${each.key}.handler"
  description   = each.value["description"]
  role          = aws_iam_role.rest_api_role.arn
  runtime       = "python3.9"

  filename         = data.archive_file.todos[each.key].output_path
  source_code_hash = data.archive_file.todos[each.key].output_base64sha256

  timeout     = each.value["timeout"]
  memory_size = each.value["memory"]

  layers = [aws_lambda_layer_version.shared.arn]

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      "TABLE" = aws_ssm_parameter.table.name
      "DEBUG" = var.env == "dev"
    }
  }
}

resource "aws_lambda_permission" "api" {
  for_each = local.lambdas

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.todos[each.key].arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*"
}
