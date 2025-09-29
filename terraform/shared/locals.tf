locals {
  # Common tags for all resources
  common_tags = {
    Project     = "public-api-gateway"
    Environment = var.environment
    ManagedBy   = "terraform"
    Repository  = "fieldnation/public-api-gateway"
  }

  # Common naming convention
  name_prefix = "${var.project_name}-${var.environment}"
}

# Environment-specific variable
variable "environment" {
  description = "Environment name (dev, next, sandbox, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "Public API"
}