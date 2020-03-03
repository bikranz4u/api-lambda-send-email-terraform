resource "aws_api_gateway_rest_api" "apigw_settemplate" {
  name        = var.apigw_settemplate
  description = "This API will invoke lambda function to use email templates."
}

resource "aws_api_gateway_resource" "settemplate_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw_settemplate.id
  parent_id   = aws_api_gateway_rest_api.apigw_settemplate.root_resource_id
  path_part   = "send"
}


resource "aws_api_gateway_method" "settemplate_post" {
  rest_api_id   = aws_api_gateway_rest_api.apigw_settemplate.id
  resource_id   = aws_api_gateway_resource.settemplate_resource.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "settemplate_int_post" {
  rest_api_id = aws_api_gateway_rest_api.apigw_settemplate.id
  resource_id = aws_api_gateway_resource.settemplate_resource.id
  http_method = aws_api_gateway_method.settemplate_post.http_method
  #type                 = "MOCK"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.set-template.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "set_prod_deployment" {
  depends_on = [
    aws_api_gateway_integration.settemplate_int_post
  ]

  rest_api_id = aws_api_gateway_rest_api.apigw_settemplate.id
  stage_name  = "prod"

}
