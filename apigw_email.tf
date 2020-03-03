resource "aws_api_gateway_rest_api" "api" {
  name        = var.apigw_send
  description = "This API will invoke lambda function to trigger email"
}

resource "aws_api_gateway_resource" "send_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "send"
}


# resource "aws_api_gateway_method" "send_options" {
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   resource_id   = aws_api_gateway_resource.send_resource.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

resource "aws_api_gateway_method" "send_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.send_resource.id
  http_method   = "POST"
  authorization = "NONE"
}


# resource "aws_api_gateway_integration" "send_integration_options" {
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   resource_id = aws_api_gateway_resource.send_resource.id
#   http_method = aws_api_gateway_method.send_options.http_method
#   # type        = "MOCK"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.lambda_send_email.invoke_arn
#   integration_http_method = "OPTIONS"
# }

resource "aws_api_gateway_integration" "send_integration_post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.send_resource.id
  http_method = aws_api_gateway_method.send_post.http_method
  #type                 = "MOCK"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_send_email.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "prod_deployment" {
  depends_on = [
    aws_api_gateway_integration.send_integration_post,

  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
}
#aws_api_gateway_integration.send_integration_options
resource "aws_api_gateway_deployment" "stage_deployment" {
  depends_on = [
    aws_api_gateway_integration.send_integration_post,

  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "stage"
}
#    aws_api_gateway_integration.send_integration_options
