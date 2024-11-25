#!/bin/bash

# Log in to Azure (if not already logged in)
az login --output none

# Set the subscription if needed (optional)
# az account set --subscription "your-subscription-id"

# Call Azure REST API to list API Management services
echo "Listing API Management services in the subscription..."

az rest --method get \
    --url "https://management.azure.com/subscriptions/{subscription-id}/providers/Microsoft.ApiManagement/service?api-version=2021-08-01" \
    --output table
