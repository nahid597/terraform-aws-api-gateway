variable "api_id" {
  description = "The ID of the API Gateway"
  type        = string
}

variable "deployment_triggers" {
  description = "Objects to force redeployment when resources/methods change"
  type        = any
}