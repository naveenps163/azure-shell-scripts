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

# Initialize total cluster count
total_aks_count=0

for subscription_id in "${subscription_ids[@]}"; do
    # Set the subscription
    az account set --subscription "$subscription_id"

    # List AKS clusters and their names
    aks_clusters=$(az aks list --query "[].{Name:name}" -o table)

    # Count the number of AKS clusters (excluding the header line)
    aks_count=$(echo "$aks_clusters" | grep -v '^Name' | wc -l)
    
    # Add to total count
    total_aks_count=$((total_aks_count + aks_count))

    # Output the subscription ID, the number of AKS clusters, and their names
    echo "Subscription: $subscription_id"
    echo "Number of AKS Clusters: $aks_count"
    echo ""
    echo "List of AKS Clusters:"
    echo "$aks_clusters"
    echo ""
done

# Output the total number of AKS clusters across all subscriptions
echo "Total Number of AKS Clusters Across All Subscriptions: $total_aks_count"
