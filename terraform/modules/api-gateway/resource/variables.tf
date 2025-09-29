variable "api_id" {
  description = "The ID of the API Gateway"
  type        = string
}

variable "parent_api_id" {
  description = "The ID of the parent API resource"
  type        = string
}

variable "resource_path" {
  description = "The path part for the API resource"
  type        = string
}
