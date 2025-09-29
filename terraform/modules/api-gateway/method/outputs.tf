output "method_id" {
  description = "The ID of the API Gateway method"
  value       = aws_api_gateway_method.api_method.id
}

output "integration_id" {
  description = "The ID of the API Gateway integration"
  value       = aws_api_gateway_integration.api_integration.id
}

output "integration_response_id" {
  description = "The ID of the API Gateway integration response"
  value       = aws_api_gateway_integration_response.api_integration_response.id
}