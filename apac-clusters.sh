#!/bin/bash

# Ensure you're logged in to Azure CLI
#az login --only-show-errors > /dev/null

# Define the list of APAC regions
# You can modify this list according to the exact regions you want to include
regions=(
    "eastasia"
    "southeastasia"
    "centralindia"
    "southindia"
    "westindia"
    "japaneast"
    "japanwest"
    "koreacentral"
    "koreasouth"
    "australiaeast"
    "australiacentral"
    "australiacentral2"
    "australiasoutheast"
    "australiasouth"
    "uaenorth"
    "saudiarabiaeast"
    "saudiarabiawest"
    "hongkong"
    "microsoftcloud"
)

# Initialize a counter for AKS clusters
total_aks_clusters=0

# Loop through each region and count AKS clusters
for region in "${regions[@]}"; do
    # Fetch AKS clusters in the current region
    aks_count=$(az aks list --query "[?location=='$region'].name" -o tsv | wc -l)
    total_aks_clusters=$((total_aks_clusters + aks_count))
done

# Output the total number of AKS clusters in APAC regions
echo "Number of AKS clusters in APAC regions: $total_aks_clusters"
