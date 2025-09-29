resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = var.api_id

  # Force a new deployment if method/resources change
  triggers = {
    redeployment = sha1(jsonencode(var.deployment_triggers))
  }

  # Ensure deployment happens after all method components are ready
  depends_on = [var.method_integration_ids]

  lifecycle {
    create_before_destroy = true
  }
}