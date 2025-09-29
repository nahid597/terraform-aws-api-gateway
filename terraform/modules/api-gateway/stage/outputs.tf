output "stage_name" {
  description = "The name of the API Gateway stage"
  value       = aws_api_gateway_stage.api_stage.stage_name
}

output "deployment_id" {
  description = "The ID of the API Gateway deployment"
  value       = aws_api_gateway_stage.api_stage.deployment_id
}

output "invoke_url" {
  description = "The invoke URL of the API Gateway stage"
  value       = aws_api_gateway_stage.api_stage.invoke_url
}