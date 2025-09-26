# get the full invoke URL including the resource path
output "api_locations_url" {
  value       = "https://${module.public_api_gateway.rest_api_id}.execute-api.${var.aws_region}.amazonaws.com/${module.api_stage.stage_name}/v1/locations"
  description = "The full invoke URL for the locations endpoint"
}