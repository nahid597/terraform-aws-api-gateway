variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "next"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "Public API"
}

variable "stage_name" {
  description = "API Gateway stage name"
  type        = string
  default     = "next"
}

# Include shared locals
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Repository  = "fieldnation/public-api-gateway"
  }

  name_prefix = "${var.project_name}-${var.environment}"
}