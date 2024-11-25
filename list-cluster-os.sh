#!/bin/bash

# List of clusters
declare -A clusters=(
  ["aks-apasp-bsn0018859-01"]="v1.27.3"
  ["aks-apasr-bsn0018647-01"]="v1.29.7"
  ["aks-apass-bsn0018649-01"]="v1.29.5"
  ["aks-apasu-bsn0018648-01"]="v1.29.7"
  ["aks-euned-bsn0013139-01"]="v1.29.2"
  ["aks-euned-bsn0020636-01"]="v1.29.2"
  ["aks-eunep-bsn0018414-01"]="v1.27.3"
  ["aks-euner-bsn0018417-01"]="v1.29.7"
  ["aks-eunes-bsn0018415-01"]="v1.29.5"
  ["aks-euneu-bsn0018416-01"]="v1.29.7"
  ["aks-euwep-bsn0018414-01"]="v1.27.3"
  ["aks-lau2p-bsn0018858-01"]="v1.28.3"
  ["aks-lau2r-bsn0018644-01"]="v1.29.8"
  ["aks-lau2s-bsn0018646-01"]="v1.29.7"
  ["aks-lau2u-bsn0018645-01"]="v1.29.7"
  ["aks-laucp-bsn0018858-01"]="v1.28.3"
  ["aks-nau2p-bsn0018857-01"]="v1.27.3"
  ["aks-nau2r-bsn0018861-01"]="v1.29.7"
  ["aks-nau2s-bsn0018863-01"]="v1.29.6"
  ["aks-nau2u-bsn0018862-01"]="v1.29.7"
)

# Function to get OS info
get_os_info() {
  kubectl get nodes -o=jsonpath='{.items[?(@.metadata.labels.node-role\.kubernetes\.io/master)].status.nodeInfo.osImage}'
}

# Loop through each cluster
for cluster in "${!clusters[@]}"; do
  echo "Cluster: $cluster (K8s version: ${clusters[$cluster]})"
  
  # Set context for the cluster (update as needed)
  kubectl config use-context $cluster
  
  # Get and print OS information
  os_info=$(get_os_info)
  echo "Operating System: $os_info"
  echo "-----------------------------------"
done
