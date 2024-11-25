#!/bin/bash

# Define a list of clusters with their namespaces
declare -A clusters=(
    ["aks-lau2p-bsn0018858-01"]="radarlive-prod"
    ["aks-nau2r-bsn0018861-01"]="radarlive-preprod"
    ["aks-eunep-bsn0018414-01"]="radarlive-prod"
    ["aks-lau2u-bsn0018645-01"]="radarlive-uat"
    ["aks-lau2s-bsn0018646-01"]="radarlive-sit"
    ["aks-nau2p-bsn0018857-01"]="radarlive-prod"
    ["aks-apasu-bsn0018648-01"]="radarlive-uat"
    ["aks-euner-bsn0018417-01"]="radarlive-preprod"
    ["aks-eunes-bsn0018415-01"]="radarlive-sit"
    ["aks-lau2r-bsn0018644-01"]="radarlive-preprod"
    ["aks-naucp-bsn0018857-01"]="radarlive-prod"
    ["aks-euneu-bsn0018416-01"]="radarlive-uat"
    ["aks-apasr-bsn0018647-01"]="radarlive-preprod"
    ["aks-euwep-bsn0018414-01"]="radarlive-prod"
    ["aks-apass-bsn0018649-01"]="radarlive-sit"
    ["aks-euned-bsn0013139-01"]="radarlive-dev"
    ["aks-laucp-bsn0018858-01"]="radarlive-prod"
    ["aks-apasp-bsn0018859-01"]="radarlive-prod"
    ["aks-nau2s-bsn0018863-01"]="radarlive-sit"
    ["aks-nau2u-bsn0018862-01"]="radarlive-uat"
)

current_cluster=""

# Main loop
while true; do
    echo -e "\nAvailable Options:"
    echo "1) List Clusters"
    echo "2) Change to a Cluster"
    echo "3) List Pods in Current Cluster"
    echo "4) Check CPU and RAM of a Pod"
    echo "5) Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo -e "\nAvailable Clusters:"
            echo "----------------------------------------"
            i=1
            for cluster in "${!clusters[@]}"; do
                printf "%d) %s - %s\n" "$i" "$cluster" "${clusters[$cluster]}"
                ((i++))
            done
            ;;

        2)
            read -p "Enter cluster number to switch (or '0' to go back): " cluster_num

            if [[ "$cluster_num" == "0" ]]; then
                continue
            fi

            selected_cluster=$(printf "%s\n" "${!clusters[@]}" | sed -n "${cluster_num}p")
            if [[ -z "$selected_cluster" ]]; then
                echo "Invalid cluster number."
                continue
            fi

            current_cluster="$selected_cluster"
            echo "Switched to context: $current_cluster"
            ;;

        3)
            if [[ -z "$current_cluster" ]]; then
                echo "No cluster selected. Please switch to a cluster first."
                continue
            fi

            namespace="${clusters[$current_cluster]}"
            echo "Fetching pods in namespace: $namespace"
            pods=$(kubectl get pods -n "$namespace" --no-headers | awk '{print $1}')
            if [[ -z "$pods" ]]; then
                echo "No pods found in namespace: $namespace"
                continue
            fi

            echo -e "\nPods in Namespace: $namespace"
            echo "----------------------------------------------------------"
            pod_array=()
            i=1
            for pod in $pods; do
                printf "%d) %s\n" "$i" "$pod"
                pod_array+=("$pod")
                ((i++))
            done
            ;;

        4)
            if [[ -z "$current_cluster" ]]; then
                echo "No cluster selected. Please switch to a cluster first."
                continue
            fi

            if [[ ${#pod_array[@]} -eq 0 ]]; then
                echo "No pods available. Please list pods first."
                continue
            fi

            read -p "Enter pod number to check CPU and RAM usage (or '0' to go back): " pod_num

            if [[ "$pod_num" == "0" ]]; then
                continue
            fi

            selected_pod=${pod_array[$((pod_num - 1))]}
            if [[ -z "$selected_pod" ]]; then
                echo "Invalid pod number."
                continue
            fi

            # Get CPU and memory usage
            metrics=$(kubectl top pod "$selected_pod" -n "${clusters[$current_cluster]}" --no-headers)
            if [[ -z "$metrics" ]]; then
                echo "Failed to retrieve metrics for pod: $selected_pod. Please check the pod name."
                continue
            fi

            echo -e "\nMetrics for pod: $selected_pod"
            echo "$metrics"
            ;;

        5)
            echo "Exiting..."
            exit 0
            ;;

        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
