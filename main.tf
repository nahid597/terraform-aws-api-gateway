provider "aws" {
  region = "us-east-2"
  profile = "personal" # Replace with your AWS CLI profile name
}

# use my existing lambda function
data "aws_lambda_function" "hello_lambda" {
  function_name = "helloWorld" 
}

# use my existing api gateway
data "aws_api_gateway_rest_api" "hello_api" {
  name = "Test Field Nation"
}

#create new resource /hello
resource "aws_api_gateway_resource" "hello_resource" {
    rest_api_id = data.aws_api_gateway_rest_api.hello_api.id
    parent_id = data.aws_api_gateway_rest_api.hello_api.root_resource_id
    path_part = "hello"
}

# create new method GET on /hello
resource "aws_api_gateway_method" "hello_get" {
    rest_api_id = data.aws_api_gateway_rest_api.hello_api.id
    resource_id = aws_api_gateway_resource.hello_resource.id
    http_method = "GET"
    authorization = "NONE"
}

# integrate GET /hello with lambda function
resource "aws_api_gateway_integration" "hello_integration" {
    rest_api_id = data.aws_api_gateway_rest_api.hello_api.id
    resource_id = aws_api_gateway_resource.hello_resource.id
    http_method = aws_api_gateway_method.hello_get.http_method
    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = data.aws_lambda_function.hello_lambda.invoke_arn
}

# give API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "allow_api_gateway" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = data.aws_lambda_function.hello_lambda.function_name
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${data.aws_api_gateway_rest_api.hello_api.execution_arn}/*/*"
}

# deploy the api to our existing stage "dev"
resource "aws_api_gateway_deployment" "hello_deployment" {
    depends_on = [ aws_api_gateway_integration.hello_integration ]
    rest_api_id = data.aws_api_gateway_rest_api.hello_api.id
    
    triggers = {
      redeployment = sha1(jsonencode(aws_api_gateway_integration.hello_integration))
    }
}

resource "aws_api_gateway_stage" "hello_stage" {
    deployment_id = aws_api_gateway_deployment.hello_deployment.id
    rest_api_id = data.aws_api_gateway_rest_api.hello_api.id
    stage_name = "dev"
}