# create a method for the API Gateway resource
resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = var.api_id
  resource_id   = var.resource_id
  http_method   = var.http_method
  authorization = var.authorization
}

# create a mock integration for the method
#TODO: change integration type based on requirement
resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.api_method.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Method Response
resource "aws_api_gateway_method_response" "api_method_response" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = "200"
}

# Mock Integration Response
resource "aws_api_gateway_integration_response" "api_integration_response" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = aws_api_gateway_method_response.api_method_response.status_code
  response_templates = {
    "application/json" = "{\"message\": \"Hello World\"}"
  }
}