output "send_api" {
  value = aws_api_gateway_rest_api.api.id
}



output "settemplate_api" {
  value = aws_api_gateway_rest_api.apigw_settemplate.id
}
