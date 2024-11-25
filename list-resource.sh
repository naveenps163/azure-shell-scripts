#!/bin/bash

# Array of subscription IDs
subscription_ids=(
    "sub-eune-dev01"
    "sub-eune-sit01"
    "sub-eune-uat01"
    "sub-eune-preprod01"
    "sub-eune-prod01"
    "sub-euwe-prod01"
    "sub-apas-sit01"
    "sub-apas-uat01"
    "sub-apas-preprod01"
    "sub-apas-prod01"
    "sub-lau2-sit01"
    "sub-lau2-uat01"
    "sub-lau2-preprod01"
    "sub-lau2-prod01"
    "sub-lauc-prod01"
    "sub-nau2-sit01"
    "sub-nau2-uat01"
    "sub-nau2-prod01"
    "sub-nauc-prod01"
)

# Log in to Azure (you may need to do this manually or configure service principal authentication)
#az login

# Initialize total resource count
total_resource_count=0

for subscription_id in "${subscription_ids[@]}"; do
    # Set the subscription
    az account set --subscription "$subscription_id"

    # List resources with their names, resource groups, and types
    resources=$(az resource list --query "[].{Name:name, ResourceGroup:resourceGroup, Type:type}" -o table)

    # Count the number of resources (excluding the header line)
    resource_count=$(echo "$resources" | grep -v '^Name' | wc -l)

    # Add to total count
    total_resource_count=$((total_resource_count + resource_count))

    # Output the subscription ID, the number of resources, and their details
    echo "Subscription: $subscription_id"
    echo "Number of Resources: $resource_count"
    echo ""
    echo "List of Resources:"
    echo "$resources"
    echo ""
done

# Output the total number of resources across all subscriptions
echo "Total Number of Resources Across All Subscriptions: $total_resource_count"
