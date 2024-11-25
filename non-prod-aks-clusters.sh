#!/bin/bash

# Ensure you're logged in to Azure CLI
#az login --only-show-errors > /dev/null

# Define the resource group
resource_group="rg-eunep-bsn0018414-01"

# Fetch the list of AKS clusters in the specified resource group
aks_clusters=$(az aks list --resource-group "$resource_group" --query "[].{Name:name, Location:location}" -o table)

# Check if there are any clusters and print the result
if [ -z "$aks_clusters" ]; then
    echo "No AKS clusters found in resource group '$resource_group'."
else
    echo "AKS clusters in resource group '$resource_group':"
    echo "$aks_clusters"
fi
