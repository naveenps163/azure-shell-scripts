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

echo "Creation Dates for each cluster:"

# Loop through each cluster
for cluster in "${clusters[@]}"; do
    kubectl config use-context "$cluster" > /dev/null 2>&1
    creation_date=$(kubectl get pod --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[0].metadata.creationTimestamp}' 2>/dev/null)
    
    if [ -z "$creation_date" ]; then
        echo "$cluster: No pods found or context error."
    else
        echo "$cluster: $creation_date"
    fi
done
