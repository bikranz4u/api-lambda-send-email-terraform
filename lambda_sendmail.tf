
locals {
  lambda_zip_location = "upload/api-lambda-send-email.zip"
}

# Archive multiple files.

data "archive_file" "send_email" {
  type        = "zip"
  output_path = local.lambda_zip_location
  source_dir  = "api-lambda-send-email"
}


resource "aws_lambda_function" "lambda_send_email" {
  function_name = var.lambda_send_email
  # The file name of the application
  filename    = local.lambda_zip_location
  description = "Function to create /send apigateway"

  # exported in that file.
  handler = "index.handler"
  runtime = "nodejs12.x"
  #Lambda Function Version
  role             = aws_iam_role.LambdaBasicExecutionRole.arn
  source_code_hash = filebase64sha256(local.lambda_zip_location)
  tags = {
    name = "serverless_send _email_api"
    env  = "sandbox"
  }
  environment {
    variables = {
      FROM_EMAIL  = var.fromEmail
      CORS_ORIGIN = var.cors_rule
    }
  }
}


# resource "aws_lambda_permission" "apigw_lambda_options" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.lambda_send_email.function_name
#   principal     = "apigateway.amazonaws.com"
#
#   # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
#   #source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:output.send_api/*/*/*"
#   #source_arn = "arn:aws:execute-api:us-east-1:305496103131:6kqry356p5/*/OPTIONS/send"
#   source_arn = "arn:aws:execute-api:us-east-1:305496103131:6kqry356p5/*/OPTIONS/send"
# }

resource "aws_lambda_permission" "apigw_lambda_post" {
  statement_id  = "AllowExecutionFromAPIGatewayPostMethod"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_send_email.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  #source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:output.send_api/*/*/*"
  #source_arn = "arn:aws:execute-api:us-east-1:305496103131:8vb56ql6w6/*/POST/send"
  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.send_post.http_method}${aws_api_gateway_resource.send_resource.path}"
}
