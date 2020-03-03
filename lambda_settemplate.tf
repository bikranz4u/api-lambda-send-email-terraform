
locals {
  lambda_set_template_location = "upload/settemplate.zip"
}

# Archive multiple files.

data "archive_file" "set-template" {
  type        = "zip"
  output_path = local.lambda_set_template_location
  source_dir  = "set-template"
}


resource "aws_lambda_function" "set-template" {
  function_name = var.lambda_set_template
  # The file name of the application
  filename    = local.lambda_set_template_location
  description = "Function to templating Email."

  # exported in that file.
  handler = "index.handler"
  runtime = "nodejs12.x"
  #Lambda Function Version
  role             = aws_iam_role.LambdaBasicExecutionRole.arn
  source_code_hash = filebase64sha256(local.lambda_set_template_location)
  tags = {
    name = "set-template"
  }
}


resource "aws_lambda_permission" "apigw_lambda_settemplate" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.set-template.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  #source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:output.settemplate_api/*/*/*"
  #source_arn = "arn:aws:execute-api:us-east-1:305496103131:gy40qjcrik/*/POST/send"
  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.apigw_settemplate.id}/*/${aws_api_gateway_method.settemplate_post.http_method}${aws_api_gateway_resource.settemplate_resource.path}"


  #source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:aws_api_gateway_rest_api.api.execution_arn/*/*/*"
}
