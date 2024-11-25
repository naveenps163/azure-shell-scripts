#!/bin/bash

# Array of clusters and their namespaces
clusters=(
    "aks-lau2p-bsn0018858-01 - radarlive-prod"
    "aks-nau2r-bsn0018861-01 - radarlive-preprod"
    "aks-eunep-bsn0018414-01 - radarlive-prod"
    "aks-lau2u-bsn0018645-01 - radarlive-uat"
    "aks-lau2s-bsn0018646-01 - radarlive-sit"
    "aks-nau2p-bsn0018857-01 - radarlive-prod"
    "aks-apasu-bsn0018648-01 - radarlive-uat"
    "aks-euner-bsn0018417-01 - radarlive-preprod"
    "aks-eunes-bsn0018415-01 - radarlive-sit"
    "aks-lau2r-bsn0018644-01 - radarlive-preprod"
    "aks-naucp-bsn0018857-01 - radarlive-prod"
    "aks-euneu-bsn0018416-01 - radarlive-uat"
    "aks-apasr-bsn0018647-01 - radarlive-preprod"
    "aks-euwep-bsn0018414-01 - radarlive-prod"
    "aks-apass-bsn0018649-01 - radarlive-sit"
    "aks-euned-bsn0013139-01 - radarlive-dev"
    "aks-laucp-bsn0018858-01 - radarlive-prod"
    "aks-apasp-bsn0018859-01 - radarlive-prod"
    "aks-nau2s-bsn0018863-01 - radarlive-sit"
    "aks-nau2u-bsn0018862-01 - radarlive-uat"
)

# Function to list clusters
list_clusters() {
    echo "Available clusters:"
    for i in "${!clusters[@]}"; do
        echo "$((i + 1)). ${clusters[$i]}"
    done
}

# Function to list roles in the current namespace
list_roles() {
    echo "Roles in $1 in $2:"
    kubectl get roles -n "$2" --context "$1" || echo "Failed to list roles."
}

# Function to list role bindings in the current namespace
list_role_bindings() {
    echo "Role bindings in $1 in $2:"
    kubectl get rolebindings -n "$2" --context "$1" || echo "Failed to list role bindings."
}

# Main menu loop
while true; do
    echo "Menu:"
    echo "1. List clusters"
    echo "2. List roles in the current namespace"
    echo "3. List role bindings in the current namespace"
    echo "4. Exit"
    read -p "Choose an option: " option

    case $option in
        1)
            list_clusters
            ;;
        2)
            read -p "Enter cluster number: " cluster_num
            read -p "Enter namespace: " namespace
            if [[ $cluster_num -ge 1 && $cluster_num -le ${#clusters[@]} ]]; then
                selected_cluster="${clusters[$((cluster_num - 1))]%% - *}"
                list_roles "$selected_cluster" "$namespace"
            else
                echo "Invalid cluster number."
            fi
            ;;
        3)
            read -p "Enter cluster number: " cluster_num
            read -p "Enter namespace: " namespace
            if [[ $cluster_num -ge 1 && $cluster_num -le ${#clusters[@]} ]]; then
                selected_cluster="${clusters[$((cluster_num - 1))]%% - *}"
                list_role_bindings "$selected_cluster" "$namespace"
            else
                echo "Invalid cluster number."
            fi
            ;;
        4)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
