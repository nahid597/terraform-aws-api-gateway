terraform {
  required_version = ">= 1.0"
  
  #TODO: we will set up when we need remote backup
#   backend "s3" {
#     # Uncomment and configure for remote state
#     # bucket = "your-terraform-state-bucket"
#     # key    = "public-api-gateway/next/terraform.tfstate"
#     # region = "us-east-1"
#   }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = local.common_tags
  }
}

# Create API Gateway
module "public_api_gateway" {
  source   = "../../modules/api-gateway/gateway"
  api_name = "Public API"
}

# Create v1 resource
module "v1_resource" {
  source        = "../../modules/api-gateway/resource"
  api_id        = module.public_api_gateway.rest_api_id
  parent_api_id = module.public_api_gateway.root_resource_id
  resource_path = "v1"
}

# Create locations resource under v1
module "locations_resource" {
  source        = "../../modules/api-gateway/resource"
  api_id        = module.public_api_gateway.rest_api_id
  parent_api_id = module.v1_resource.api_resource_id
  resource_path = "locations"
}

# Create GET method for locations
module "locations_get_method" {
  source        = "../../modules/api-gateway/method"
  api_id        = module.public_api_gateway.rest_api_id
  resource_id   = module.locations_resource.api_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

# Deploy the API
module "api_deployment" {
  source = "../../modules/api-gateway/deployment"
  api_id = module.public_api_gateway.rest_api_id
  deployment_triggers = {
    methods   = "GET"
    resources = module.locations_resource.api_resource_id
  }
  method_integration_ids = [
    module.locations_get_method.integration_response_id
  ]
}

# Create stage
module "api_stage" {
  source        = "../../modules/api-gateway/stage"
  api_id        = module.public_api_gateway.rest_api_id
  stage_name    = var.stage_name
  deployment_id = module.api_deployment.api_deployment_id
}
