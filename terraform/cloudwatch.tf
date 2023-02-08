resource "aws_cloudwatch_log_group" "this" {
  for_each = aws_lambda_function.this

  name              = "/aws/lambda/${each.value.function_name}"
  retention_in_days = 3
}
