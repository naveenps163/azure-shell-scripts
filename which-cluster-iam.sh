#!/bin/bash

# Ensure kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed. Please install it and try again."
    exit 1
fi

# Get the current context
current_context=$(kubectl config current-context)

if [ -z "$current_context" ]; then
    echo "No current context is set in kubectl configuration."
    exit 1
fi

# Get the cluster details from the current context
cluster_name=$(kubectl config view -o jsonpath="{.contexts[?(@.name == \"$current_context\")].context.cluster}")

# Get the cluster details from the cluster name
cluster_info=$(az aks show --name "$cluster_name" --query "{Name:name, ResourceGroup:resourceGroup, Location:location}" -o table)

if [ -z "$cluster_info" ]; then
    echo "No AKS cluster found with the name $cluster_name."
    exit 1
fi

# Output the current AKS cluster details
echo "Current AKS Cluster Details:"
echo "$cluster_info"
