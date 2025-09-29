output "api_resource_id" {
  value       = aws_api_gateway_resource.api_resource.id
  description = "The ID of the API Gateway Resource"
}

output "resource_path" {
  value       = aws_api_gateway_resource.api_resource.path_part
  description = "The path part of the API Gateway Resource"
}

output "full_path" {
  value       = aws_api_gateway_resource.api_resource.path
  description = "The full path of the API Gateway Resource"
}