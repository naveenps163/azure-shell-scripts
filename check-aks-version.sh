#!/bin/bash

# Define the cluster and resource group names
CLUSTER_NAME="aks-nau2s-bsn0018863-01"
RESOURCE_GROUP="rg-nau2s-bsn0018863-01"

# Get the AKS cluster details
aks_details=$(az aks show --name "$CLUSTER_NAME" --resource-group "$RESOURCE_GROUP" --query "{currentVersion: kubernetesVersion, lastUpdate: upgradeProfile.lastUpgradeTime, lastVersion: upgradeProfile.versions[-1]}" -o tsv)

# Read the details into variables
IFS=$'\t' read -r current_version last_update last_version <<< "$aks_details"

# Output the results
echo "Cluster Name: $CLUSTER_NAME"
echo "Resource Group: $RESOURCE_GROUP"
echo "Current AKS Version: $current_version"
echo "Last AKS Version: $last_version"
echo "Last Update Date: $last_update"
