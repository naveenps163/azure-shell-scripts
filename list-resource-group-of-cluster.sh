#!/bin/bash

# List all AKS clusters in the current subscription
echo "Listing all AKS clusters in the current subscription:"
az aks list --query "[].{name:name, resourceGroup:resourceGroup}" -o table

# Declare an array of AKS clusters
clusters=(
    "aks-lau2p-bsn0018858-01"
    "aks-nau2r-bsn0018861-01"
    "aks-eunep-bsn0018414-01"
    "aks-lau2u-bsn0018645-01"
    "aks-lau2s-bsn0018646-01"
    "aks-nau2p-bsn0018857-01"
    "aks-apasu-bsn0018648-01"
    "aks-euner-bsn0018417-01"
    "aks-eunes-bsn0018415-01"
    "aks-lau2r-bsn0018644-01"
    "aks-naucp-bsn0018857-01"
    "aks-euneu-bsn0018416-01"
    "aks-apasr-bsn0018647-01"
    "aks-euwep-bsn0018414-01"
    "aks-apass-bsn0018649-01"
    "aks-euned-bsn0013139-01"
    "aks-laucp-bsn0018858-01"
    "aks-apasp-bsn0018859-01"
    "aks-nau2s-bsn0018863-01"
    "aks-nau2u-bsn0018862-01"
    "aks-eunep-bsn0018414-01"
)

# Loop through each cluster to get its resource group
for cluster in "${clusters[@]}"; do
    # Get the resource group of the AKS cluster
    resource_group=$(az aks show --name "$cluster" --query "resourceGroup" -o tsv 2>/dev/null)

    # Output the cluster and its resource group
    if [[ -z "$resource_group" ]]; then
        echo "Failed to retrieve resource group for cluster: $cluster."
    else
        echo "Cluster: $cluster | Resource Group: $resource_group"
    fi
done
