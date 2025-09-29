output "api_gateway_url" {
  description = "Base URL of the API Gateway"
  value       = module.api_stage.invoke_url
}

output "locations_endpoint_url" {
  description = "Full URL for the locations endpoint"
  value       = "${module.api_stage.invoke_url}${module.locations_resource.full_path}"
}

output "api_id" {
  description = "ID of the API Gateway"
  value       = module.public_api_gateway.rest_api_id
}

output "stage_name" {
  description = "Name of the deployed stage"
  value       = module.api_stage.stage_name
}