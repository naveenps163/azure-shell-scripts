#!/bin/bash

# Define the clusters and their respective contexts and namespaces
declare -A clusters=(
    ["aks-apasp-bsn0018859-01"]="clusterUser_rg-apasp-bsn0018859-01_aks-apasp-bsn0018859-01:radarlive-prod"
    ["aks-apasr-bsn0018647-01"]="clusterUser_rg-apasr-bsn0018647-01_aks-apasr-bsn0018647-01:radarlive-preprod"
    ["aks-apass-bsn0018649-01"]="clusterUser_rg-apass-bsn0018649-01_aks-apass-bsn0018649-01:radarlive-sit"
    ["aks-apasu-bsn0018648-01"]="clusterUser_rg-apasu-bsn0018648-01_aks-apasu-bsn0018648-01:radarlive-uat"
    ["aks-euned-bsn0013139-01"]="clusterUser_rg-euned-bsn0013139-01_aks-euned-bsn0013139-01:radarlive-dev"
    ["aks-euned-bsn0020636-01"]="clusterUser_rg-euned-bsn0020636-01_aks-euned-bsn0020636-01:radarlive-dev"
    ["aks-eunep-bsn0018414-01"]="clusterUser_rg-eunep-bsn0018414-01_aks-eunep-bsn0018414-01:radarlive-prod"
    ["aks-euner-bsn0018417-01"]="clusterUser_rg-euner-bsn0018417-01_aks-euner-bsn0018417-01:radarlive-preprod"
    ["aks-eunes-bsn0018415-01"]="clusterUser_rg-eunes-bsn0018415-01_aks-eunes-bsn0018415-01:radarlive-sit"
    ["aks-euneu-bsn0018416-01"]="clusterUser_rg-euneu-bsn0018416-01_aks-euneu-bsn0018416-01:radarlive-uat"
    ["aks-euwep-bsn0018414-01"]="clusterUser_rg-euwep-bsn0018414-01_aks-euwep-bsn0018414-01:radarlive-prod"
    ["aks-lau2p-bsn0018858-01"]="clusterUser_rg-lau2p-bsn0018858-01_aks-lau2p-bsn0018858-01:radarlive-prod"
    ["aks-lau2r-bsn0018644-01"]="clusterUser_rg-lau2r-bsn0018644-01_aks-lau2r-bsn0018644-01:radarlive-preprod"
    ["aks-lau2s-bsn0018646-01"]="clusterUser_rg-lau2s-bsn0018646-01_aks-lau2s-bsn0018646-01:radarlive-sit"
    ["aks-lau2u-bsn0018645-01"]="clusterUser_rg-lau2u-bsn0018645-01_aks-lau2u-bsn0018645-01:radarlive-uat"
    ["aks-laucp-bsn0018858-01"]="clusterUser_rg-laucp-bsn0018858-01_aks-laucp-bsn0018858-01:radarlive-prod"
    ["aks-nau2p-bsn0018857-01"]="clusterUser_rg-nau2p-bsn0018857-01_aks-nau2p-bsn0018857-01:radarlive-prod"
    ["aks-nau2r-bsn0018861-01"]="clusterUser_rg-nau2r-bsn0018861-01_aks-nau2r-bsn0018861-01:radarlive-preprod"
    ["aks-nau2s-bsn0018863-01"]="clusterUser_rg-nau2s-bsn0018863-01_aks-nau2s-bsn0018863-01:radarlive-sit"
    ["aks-nau2u-bsn0018862-01"]="clusterUser_rg-nau2u-bsn0018862-01_aks-nau2u-bsn0018862-01:radarlive-uat"
    ["aks-naucp-bsn0018857-01"]="clusterUser_rg-naucp-bsn0018857-01_aks-naucp-bsn0018857-01:radarlive-prod"
)

# Loop through the clusters and list pods in the specified namespaces
for cluster in "${!clusters[@]}"; do
    IFS=":" read -r context namespace <<< "${clusters[$cluster]}"
    
    echo "Attempting to list pods in cluster: $cluster (Context: $context, Namespace: $namespace)"
    
    # Check if the context exists
    if kubectl config get-contexts | grep -q "$context"; then
        kubectl config use-context "$context"
        
        # Check permissions
        if kubectl auth can-i list pods -n "$namespace"; then
            kubectl get pods -n "$namespace"
        else
            echo "Error: User does not have permission to list pods in namespace: $namespace"
        fi
    else
        echo "Error: No context exists with the name: $context"
    fi
    
    echo "-------------------------------------"
done
