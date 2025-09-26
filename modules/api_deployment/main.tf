resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = var.api_id

  # Force a new deployment if method/resources change
  triggers = {
    redeployment = sha1(jsonencode(var.deployment_triggers))
  }

  lifecycle {
    create_before_destroy = true
  }
}