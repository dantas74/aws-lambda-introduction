data "archive_file" "shared_layer" {
  output_path = "files/shared-layer.zip"
  type        = "zip"
  source_dir  = local.layer_path
}

data "archive_file" "lib_layer" {
  output_path = "files/lib-layer.zip"
  type        = "zip"
  source_dir  = local.lib_path
}

resource "aws_lambda_layer_version" "shared" {
  layer_name          = "shared-layer"
  description         = "Shared layer for functions"
  filename            = data.archive_file.shared_layer.output_path
  source_code_hash    = data.archive_file.shared_layer.output_base64sha256
  compatible_runtimes = ["python3.9"]
}

resource "aws_lambda_layer_version" "lib" {
  layer_name          = "lib"
  description         = "Library layer for functions"
  filename            = data.archive_file.lib_layer.output_path
  source_code_hash    = data.archive_file.lib_layer.output_base64sha256
  compatible_runtimes = ["python3.9"]
}

data "archive_file" "lambdas" {
  for_each = local.lambdas

  output_path = "files/${each.value}-artifact.zip"
  type        = "zip"
  source_file = "${path.module}/../lambdas/${each.value}"
}

resource "aws_lambda_function" "this" {
  for_each = {
    for file_path in local.lambdas : file_path => {
      function_name    = "dynamodb-${replace(join("-", slice(split("/", file_path), 1, length(split("/", file_path)) - 1)), "_", "")}-${split(".", split("/", file_path)[length(split("/", file_path)) - 1])[0]}-item"
      handler          = "${split(".", split("/", file_path)[length(split("/", file_path)) - 1])[0]}.handler"
      filename         = data.archive_file.lambdas[file_path].output_path
      source_code_hash = data.archive_file.lambdas[file_path].output_base64sha256
      timeout          = contains(local.get_functions, file_path) ? 10 : 5
      memory           = contains(local.get_functions, file_path) ? 256 : 128
    }
  }

  function_name = each.value["function_name"]
  handler       = each.value["handler"]
  role          = aws_iam_role.rest_api_role.arn
  runtime       = "python3.9"

  filename         = each.value["filename"]
  source_code_hash = each.value["source_code_hash"]

  timeout     = each.value["timeout"]
  memory_size = each.value["memory"]

  layers = [aws_lambda_layer_version.shared.arn, aws_lambda_layer_version.lib.arn]

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      "DEBUG" = var.env == "dev"
    }
  }
}

resource "aws_lambda_permission" "this" {
  for_each = aws_lambda_function.this

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this[each.key].arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*"
}
