# Current AWS account and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Availability zones
data "aws_availability_zones" "available" {
  state = "available"
}