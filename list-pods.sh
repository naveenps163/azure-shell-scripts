#!/bin/bash

# Array of clusters and their accessible namespaces
declare -A clusters_and_namespaces=(
    ["aks-lau2u-bsn0018645-01"]="radarlive-uat"   # Able to access
    ["aks-lau2s-bsn0018646-01"]="radarlive-sit"   # Able to access
    ["aks-apasu-bsn0018648-01"]="radarlive-uat"    # Able to access
    ["aks-euneu-bsn0018416-01"]="radarlive-uat"    # Able to access
    ["aks-apass-bsn0018649-01"]="radarlive-sit"     # Able to access
    ["aks-euned-bsn0013139-01"]="radarlive-dev"     # Able to access
    ["aks-nau2s-bsn0018863-01"]="radarlive-sit"     # Able to access
    ["aks-nau2u-bsn0018862-01"]="radarlive-uat"     # Able to access
)

# Clusters without access
declare -A inaccessible_clusters=(
    ["aks-lau2p-bsn0018858-01"]="radarlive-prod" 
    ["aks-nau2r-bsn0018861-01"]="radarlive-preprod" 
    ["aks-eunep-bsn0018414-01"]="radarlive-prod" 
    ["aks-nau2p-bsn0018857-01"]="radarlive-prod" 
    ["aks-euner-bsn0018417-01"]="radarlive-preprod" 
    ["aks-eunes-bsn0018415-01"]="radarlive-sit" 
    ["aks-lau2r-bsn0018644-01"]="radarlive-preprod" 
    ["aks-naucp-bsn0018857-01"]="radarlive-prod" 
    ["aks-apasr-bsn0018647-01"]="radarlive-preprod" 
    ["aks-euwep-bsn0018414-01"]="radarlive-prod" 
    ["aks-laucp-bsn0018858-01"]="radarlive-prod" 
    ["aks-apasp-bsn0018859-01"]="radarlive-prod" 
)

# Print the header for accessible clusters
printf "%-30s %-20s %-80s\n" "Cluster" "Namespace" "Pods"
printf "%-30s %-20s %-80s\n" "-------" "---------" "----"

# Loop through each accessible cluster and namespace
for cluster in "${!clusters_and_namespaces[@]}"; do
    namespace=${clusters_and_namespaces[$cluster]}
    
    # Switch to the cluster context without printing messages
    kubectl config use-context "$cluster" > /dev/null 2>&1

    # Get the list of pods in the namespace
    pods=$(kubectl get pods -n "$namespace" --no-headers 2>/dev/null | awk '{print $1}' ORS=', ')
    
    # Check if there are any pods and format output
    if [ -z "$pods" ]; then
        printf "%-30s %-20s %-80s\n" "$cluster" "$namespace" "No pods found"
    else
        # Remove trailing comma and space
        pods=${pods%, }
        printf "%-30s %-20s %-80s\n" "$cluster" "$namespace" "$pods"
    fi
done

# Print the header for inaccessible clusters
printf "\n\n%-30s %-20s %-80s\n" "Inaccessible Clusters" "Namespace" "Pods"
printf "%-30s %-20s %-80s\n" "--------------------" "--------- " "----"

# Loop through each inaccessible cluster
for cluster in "${!inaccessible_clusters[@]}"; do
    namespace=${inaccessible_clusters[$cluster]}
    
    # Attempt to switch to the inaccessible cluster context without printing messages
    kubectl config use-context "$cluster" > /dev/null 2>&1

    # Try to get the list of pods in the namespace
    pods=$(kubectl get pods -n "$namespace" --no-headers 2>/dev/null | awk '{print $1}' ORS=', ')
    
    # Check if there are any pods and format output
    if [ -z "$pods" ]; then
        printf "%-30s %-20s %-80s\n" "$cluster" "$namespace" "Not able to access pods"
    else
        # Remove trailing comma and space
        pods=${pods%, }
        printf "%-30s %-20s %-80s\n" "$cluster" "$namespace" "$pods"
    fi
done

# Summary of counts
echo -e "\nTotal Accessible Clusters: ${#clusters_and_namespaces[@]}"
echo -e "Total Inaccessible Clusters: ${#inaccessible_clusters[@]}"
