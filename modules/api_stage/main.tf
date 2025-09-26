resource "aws_api_gateway_stage" "api_stage" {
  rest_api_id = var.api_id
  stage_name  = var.stage_name
  deployment_id = var.deployment_id
}