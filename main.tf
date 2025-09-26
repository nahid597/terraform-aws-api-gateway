
provider "aws" {
  region  = var.aws_region
  profile = "personal" # Replace with your AWS CLI profile name
}

# Create a new API Gateway
module "public_api_gateway" {
  source   = "./modules/api_gateway"
  api_name = "Public API"
}

# create a new resource version v1
module "locations_resource" {
  source        = "./modules/api_resource"
  api_id        = module.public_api_gateway.rest_api_id
  parent_api_id = module.public_api_gateway.root_resource_id
  resource_path = "v1"
}

# create a new sub-resource locations under v1
module "locations_sub_resource" {
  source        = "./modules/api_resource"
  api_id        = module.public_api_gateway.rest_api_id
  parent_api_id = module.locations_resource.api_resource_id
  resource_path = "locations"
}

# create GET method with Mock response for locations resource
module "get_locations_method" {
  source        = "./modules/api_method"
  api_id        = module.public_api_gateway.rest_api_id
  resource_id   = module.locations_sub_resource.api_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

# Deploy the API
module "api_deployment" {
  source = "./modules/api_deployment"
  api_id = module.public_api_gateway.rest_api_id
  deployment_triggers = {
    methods   = "GET"
    resources = module.locations_sub_resource.api_resource_id
  }
}

# Create a stage for the deployed API
module "api_stage" {
  source        = "./modules/api_stage"
  api_id        = module.public_api_gateway.rest_api_id
  stage_name    = "next"
  deployment_id = module.api_deployment.api_deployment_id
}