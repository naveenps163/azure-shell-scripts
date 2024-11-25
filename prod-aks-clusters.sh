#!/bin/bash

# Ensure you're logged in to Azure CLI
#az login --only-show-errors > /dev/null

# List of resource groups to check
resource_groups=(
    "prod-ap-cogsharedsvc-radarlive-aks-reg1-01"
    "prod-na-cogsharedsvc-radarlive-aks-reg1-01"
    "rg-nau2p-bsn0018859-01"
    "rg-apasp-bsn0018859-01"
    "rg-lau2p-bsn0018858-01"
    "rg-eunep-bsn0018414-01"
    "rg-euwep-bsn0018414-01"
    "rg-nau2p-bsn0018857-01"
    "rg-naucp-bsn0018857-01"
    "rg-laucp-bsn0018858-01"
)

# Initialize a counter for AKS clusters
total_aks_clusters=0

# Loop through each resource group and count AKS clusters
for rg in "${resource_groups[@]}"; do
    echo "Checking resource group: $rg"
    
    # Fetch AKS clusters in the current resource group
    aks_count=$(az aks list --resource-group "$rg" --query "length([])" -o tsv)
    total_aks_clusters=$((total_aks_clusters + aks_count))
    
    echo "Number of AKS clusters in resource group '$rg': $aks_count"
done

# Output the total number of AKS clusters
echo "Total number of AKS clusters in specified resource groups: $total_aks_clusters"
