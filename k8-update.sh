#!/bin/bash

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed. Please install it to continue."
    exit 1
fi

# Array of cluster names
clusters=(
    "aks-apasp-bsn0018859-01"
    "aks-apasr-bsn0018647-01"
    "aks-apass-bsn0018649-01"
    "aks-apasu-bsn0018648-01"
    "aks-euned-bsn0013139-01"
    "aks-euned-bsn0020636-01"
    "aks-eunep-bsn0018414-01"
    "aks-euner-bsn0018417-01"
    "aks-eunes-bsn0018415-01"
    "aks-euneu-bsn0018416-01"
    "aks-euwep-bsn0018414-01"
    "aks-lau2p-bsn0018858-01"
    "aks-lau2r-bsn0018644-01"
    "aks-lau2s-bsn0018646-01"
    "aks-lau2u-bsn0018645-01"
    "aks-laucp-bsn0018858-01"
    "aks-nau2p-bsn0018857-01"
    "aks-nau2r-bsn0018861-01"
    "aks-nau2s-bsn0018863-01"
    "aks-nau2u-bsn0018862-01"
)

# Print header for the table
echo -e "Cluster Name\t\t\t\t\tKubernetes Version"

# Loop through each cluster and print the version in table format
for cluster in "${clusters[@]}"; do
    # Ensure the context exists in the kubeconfig
    if ! kubectl config get-contexts "$cluster" &> /dev/null; then
        echo -e "$cluster\t\t\tContext not found"
        continue
    fi
    
    # Switch to the cluster context
    if ! kubectl config use-context "$cluster" &> /dev/null; then
        echo -e "$cluster\t\t\tFailed to switch"
        continue
    fi

    # Get Kubernetes version and suppress warnings
    k8s_version=$(kubectl version --short 2>/dev/null | grep "Server" | awk '{print $3}')
    
    if [ -z "$k8s_version" ]; then
        echo -e "$cluster\t\t\tCould not retrieve version"
    else
        # Print the cluster name and version in a formatted table row
        printf "%-35s\t%s\n" "$cluster" "$k8s_version"
    fi
done
