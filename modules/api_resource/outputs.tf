output "api_resource_id" {
  value       = aws_api_gateway_resource.api_resource.id
  description = "The ID of the API Gateway Resource"
}