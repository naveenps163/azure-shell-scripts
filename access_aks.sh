#!/bin/bash

# Ensure Azure CLI is logged in
#az login --only-show-errors > /dev/null

# Check if both resource group and cluster name arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <resource-group> <cluster-name>"
  exit 1
fi

# Get the resource group and cluster name from the input arguments
RESOURCE_GROUP=$1
CLUSTER_NAME=$2

# Get the AKS cluster credentials
az aks get-credentials --resource-group "$RESOURCE_GROUP" --name "$CLUSTER_NAME"

# Check if kubectl command was successful
if [ $? -eq 0 ]; then
  echo "Successfully configured kubectl to use AKS cluster $CLUSTER_NAME in resource group $RESOURCE_GROUP."
  echo "You can now run kubectl commands to interact with the cluster."
else
  echo "Failed to get credentials for AKS cluster $CLUSTER_NAME."
  exit 1
fi
