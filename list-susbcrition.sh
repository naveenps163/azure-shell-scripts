#!/bin/bash

# Check if Azure CLI is installed
if ! command -v az &> /dev/null
then
    echo "Azure CLI could not be found. Please install it."
    exit 1
fi

# Print the header for the table
printf "+-----------------------------------------+---------------------+---------------------+\n"
printf "|               Cluster Name              |   Resource Group    |   Kubernetes Version  |\n"
printf "+-----------------------------------------+---------------------+---------------------+\n"

# List all AKS clusters in the subscription
aks_clusters=$(az aks list --query "[].{name:name, resourceGroup:resourceGroup}" -o tsv)

# Loop through each cluster and check its Kubernetes version
while IFS=$'\t' read -r cluster_name resource_group; do
    # Get the Kubernetes version associated with the AKS cluster
    kubernetes_version=$(az aks show --name "$cluster_name" --resource-group "$resource_group" --query "kubernetesVersion" -o tsv 2>/dev/null)

    if [ -z "$kubernetes_version" ]; then
        printf "| %-37s | %-20s | %-20s |\n" "$cluster_name" "$resource_group" "Not Found"
    else
        printf "| %-37s | %-20s | %-20s |\n" "$cluster_name" "$resource_group" "$kubernetes_version"
    fi
done <<< "$aks_clusters"

printf "+-----------------------------------------+---------------------+---------------------+\n"
