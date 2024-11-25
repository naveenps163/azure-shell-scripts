#!/bin/bash

# Define clusters and namespaces mapping
declare -A clusters=(
    ["aks-apasp-bsn0018859-01"]="radarlive-prod"
    ["aks-apasr-bsn0018647-01"]="radarlive-preprod"
    ["aks-apass-bsn0018649-01"]="radarlive-sit"
    ["aks-apasu-bsn0018648-01"]="radarlive-uat"
    ["aks-euned-bsn0013139-01"]="radarlive-dev"
    ["aks-eunep-bsn0018414-01"]="radarlive-prod"
    ["aks-euner-bsn0018417-01"]="radarlive-preprod"
    ["aks-eunes-bsn0018415-01"]="radarlive-sit"
    ["aks-euneu-bsn0018416-01"]="radarlive-uat"
    ["aks-euwep-bsn0018414-01"]="radarlive-prod"
    ["aks-lau2p-bsn0018858-01"]="radarlive-prod"
    ["aks-lau2r-bsn0018644-01"]="radarlive-preprod"
    ["aks-lau2s-bsn0018646-01"]="radarlive-sit"
    ["aks-lau2u-bsn0018645-01"]="radarlive-uat"
    ["aks-laucp-bsn0018858-01"]="radarlive-prod"
    ["aks-nau2p-bsn0018857-01"]="radarlive-prod"
    ["aks-nau2r-bsn0018861-01"]="radarlive-preprod"
    ["aks-nau2s-bsn0018863-01"]="radarlive-sit"
    ["aks-nau2u-bsn0018862-01"]="radarlive-uat"
    ["aks-naucp-bsn0018857-01"]="radarlive-prod"
)

# Function to list all clusters and namespaces with numbers
list_clusters() {
    echo "Available clusters and their namespaces:"
    i=1
    for cluster in "${!clusters[@]}"; do
        echo "$i) $cluster => ${clusters[$cluster]}"
        ((i++))
    done
}

# Function to switch to the selected cluster
switch_cluster() {
    local cluster_name=$1
    echo "Switching to cluster: $cluster_name"
    
    # Assuming kubectl context is named as cluster_name
    if kubectl config get-contexts "$cluster_name" > /dev/null 2>&1; then
        kubectl config use-context "$cluster_name"
        echo "Switched to cluster: $cluster_name"
    else
        echo "Error: Cluster context '$cluster_name' not found."
        exit 1
    fi
}

# Function to fetch pods from a cluster and namespace
fetch_pods() {
    local namespace=$1
    echo "Fetching running pods in namespace: $namespace..."
    kubectl get pods -n "$namespace" -o=jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{range .spec.containers[*]}{.image}{"\t"}{end}{"\n"}{end}'
}

# Main execution
echo "1. Listing all clusters and namespaces..."
list_clusters

# Prompt the user to select a cluster by number
echo -n "Enter the number of the cluster to switch to: "
read selected_number

# Validate if the input number is valid
if ! [[ "$selected_number" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a number."
    exit 1
fi

# Find the cluster by number
cluster_name=$(echo "${!clusters[@]}" | cut -d' ' -f"$selected_number")
namespace="${clusters[$cluster_name]}"

if [ -z "$cluster_name" ]; then
    echo "Error: Invalid selection. Please choose a valid number."
    exit 1
fi

# Step 2: Switch to the selected cluster
switch_cluster "$cluster_name"

# Step 3: Fetch pods from the corresponding namespace
fetch_pods "$namespace"
