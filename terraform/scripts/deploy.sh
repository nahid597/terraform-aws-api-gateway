#!/bin/bash

# Deployment script for Terraform environments
set -e

ENVIRONMENT=${1:-dev}
ACTION=${2:-plan}

if [ ! -d "environments/$ENVIRONMENT" ]; then
    echo "Environment $ENVIRONMENT does not exist!"
    exit 1
fi

echo "🚀 Running Terraform $ACTION for $ENVIRONMENT environment..."

cd "environments/$ENVIRONMENT"

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

case $ACTION in
    "plan")
        terraform plan
        ;;
    "apply")
        terraform plan -out=tfplan
        echo "Review the plan above. Do you want to apply? (yes/no)"
        read -r response
        if [ "$response" = "yes" ]; then
            terraform apply tfplan
            rm tfplan
        else
            echo "Deployment cancelled."
            rm tfplan
        fi
        ;;
    "destroy")
        terraform plan -destroy
        echo "⚠️  This will DESTROY all resources! Are you sure? (yes/no)"
        read -r response
        if [ "$response" = "yes" ]; then
            terraform destroy
        else
            echo "Destroy cancelled."
        fi
        ;;
    *)
        echo "Usage: $0 <environment> <plan|apply|destroy>"
        exit 1
        ;;
esac

echo "✅ Terraform $ACTION completed for $ENVIRONMENT!"