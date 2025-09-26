variable "api_id" {
  description = "The ID of the API Gateway"
  type        = string
}

variable "resource_id" {
  description = "The ID of the parent API resource"
  type        = string
}

variable "http_method" {
  description = "The HTTP method for the API method (e.g., GET, POST)"
  type        = string
}

variable "authorization" {
  description = "The authorization type for the API method (e.g., NONE, AWS_IAM, CUSTOM, COGNITO_USER_POOLS)"
  type        = string
  default     = "NONE"
}