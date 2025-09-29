# Terraform For Public API Gateway

A comprehensive Terraform project for managing AWS API Gateway and related infrastructure resources.

## 📁 Project Structure

```
public-api-gateway/
├── terraform/
│   ├── environments/                    # Environment-specific configurations
│   │   └── next/                       # Next environment
│   │       ├── main.tf                 # Main configuration
│   │       ├── variables.tf            # Environment variables
│   │       └── outputs.tf              # Environment outputs
│   ├── modules/                        # Reusable Terraform modules
│   │   └── api-gateway/                # API Gateway modules
│   │       ├── gateway/                # Basic API Gateway
│   │       ├── resource/               # API resources
│   │       ├── method/                 # API methods
│   │       ├── deployment/             # API deployment
│   │       └── stage/                  # API stage
│   ├── shared/                         # Shared configurations
│   │   ├── locals.tf                   # Common local values
│   │   ├── data.tf                     # Common data sources
│   │   └── versions.tf                 # Provider versions
│   └── scripts/                        # Helper scripts
│       └── deploy.sh                   # Deployment script
├── .gitignore
└── README.md
```

## 🚀 Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with necessary permissions

### Deploy to Next Environment

1. **Navigate to the next environment:**
   ```bash
   cd terraform/environments/next
   ```

2. **Update configuration:**
   Edit `terraform.tfvars` to match your AWS profile and preferences:
   ```hcl
   aws_region    = "us-east-1"
   aws_profile   = "your-profile-name"
   environment   = "next"
   project_name  = "Public API"
   stage_name    = "next"
   ```

3. **Deploy using the helper script:**
   ```bash
   # From terraform/ directory
   ./scripts/deploy.sh next plan    # Review changes
   ./scripts/deploy.sh next apply   # Apply changes
   ```

   Or manually:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Removed changes using the helper script:**
   ```bash
   # From terraform/ directory
   ./scripts/deploy.sh next destroy   # Removed all changes
   ```

   Or manually:
   ```bash
   terraform destroy # removed all changes
   ```

### Deploy to Other Environments

1. **Create staging/prod environments:**
   ```bash
   cp -r environments/next environments/staging
   cp -r environments/next environments/prod
   ```

2. **Update environment-specific values:**
   - Modify `terraform.tfvars` in each environment
   - Update `backend.tf` for remote state (recommended for prod)

3. **Deploy:**
   ```bash
   ./scripts/deploy.sh staging apply
   ./scripts/deploy.sh prod apply
   ```

## 🏗️ Architecture

### Current Implementation

The project creates a complete API Gateway setup with:

- **API Gateway:** "Public API" REST API
- **Resources:** `/v1/locations` endpoint structure
- **Methods:** GET method with mock integration
- **Deployment:** Automated deployment with versioning
- **Stage:** "next" stage

### API Endpoints

After deployment, you'll have:
```
https://{api-id}.execute-api.{region}.amazonaws.com/next/v1/locations
```

## 📝 Module Usage

### Direct Module Usage (Recommended)

Use individual modules directly for maximum flexibility and clarity:

```hcl
# Create API Gateway
module "public_api_gateway" {
  source   = "../../modules/api-gateway/gateway"
  api_name = "Public API"
}

# Create API resources
module "v1_resource" {
  source        = "../../modules/api-gateway/resource"
  api_id        = module.public_api_gateway.rest_api_id
  parent_api_id = module.public_api_gateway.root_resource_id
  resource_path = "v1"
}

module "locations_resource" {
  source        = "../../modules/api-gateway/resource"
  api_id        = module.public_api_gateway.rest_api_id
  parent_api_id = module.v1_resource.api_resource_id
  resource_path = "locations"
}

# Create methods
module "locations_get_method" {
  source        = "../../modules/api-gateway/method"
  api_id        = module.public_api_gateway.rest_api_id
  resource_id   = module.locations_resource.api_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

# Deploy and stage
module "api_deployment" {
  source = "../../modules/api-gateway/deployment"
  api_id = module.public_api_gateway.rest_api_id
  # ... other configuration
}

module "api_stage" {
  source        = "../../modules/api-gateway/stage"
  api_id        = module.public_api_gateway.rest_api_id
  stage_name    = "next"
  deployment_id = module.api_deployment.api_deployment_id
}
```

## 🔧 Extending the Project

### Adding New Resources

1. **Create new modules** in the appropriate directory:
   ```
   modules/
   ├── lambda/function/
   ├── database/dynamodb/
   └── networking/vpc/
   ```

2. **Use in environments:**
   ```hcl
   module "lambda_functions" {
     source = "../../modules/lambda/function"
     # ... configuration
   }
   ```

### Adding New Environments

1. **Copy existing environment:**
   ```bash
   cp -r environments/next environments/test
   ```

2. **Update configuration:**
   - Modify `terraform.tfvars`
   - Update `backend.tf` for unique state storage

### Remote State Configuration

For production environments, configure remote state:

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "public-api-gateway/prod/terraform.tfstate"
    region = "us-east-1"
  }
}
```

## 🛡️ Best Practices

### Environment-Based Deployment

1. **Always Deploy from Environment Directories:**
   ```bash
   # ✅ Correct - Deploy from environment directory
   cd terraform/environments/next
   terraform apply
   
   # ❌ Incorrect - No root-level deployment
   cd terraform
   terraform apply  # This won't work!
   ```

2. **Environment Isolation:** Each environment has its own:
   - State file (local or remote)
   - Variable values
   - Resource naming
   - Configuration

3. **Module Reusability:** Modules are designed to be reusable across environments

4. **Consistent Tagging:** All resources are tagged with environment and project information


## 🤝 Contributing

1. Create feature branches for new functionality
2. Test changes in the next environment first
3. Update documentation for new modules or changes
4. Follow Terraform best practices and naming conventions
5. Always deploy from environment directories, never from root
