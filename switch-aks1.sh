#!/bin/bash

# Define clusters and their namespaces
declare -A CLUSTERS_NAMESPACES=( 
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

# Initialize current cluster
current_cluster=""

# Function to switch context
switch_context() {
    local context=$1
    echo "Switching to context: $context"
    kubectl config use-context "$context"
    
    if [ $? -eq 0 ]; then
        echo "Switched to $context successfully."
        current_cluster="$context"
    else
        echo "Failed to switch to $context."
    fi
}

# Function to list pods
list_pods() {
    local namespace=$1
    echo "Listing pods in namespace '$namespace'..."
    kubectl get pods -n "$namespace"
}

# Function to describe a pod
describe_pod() {
    local namespace=$1
    echo "Listing pods in namespace '$namespace'..."
    pods=$(kubectl get pods -n "$namespace" -o jsonpath='{.items[*].metadata.name}')

    if [ -z "$pods" ]; then
        echo "No pods found in namespace '$namespace'."
        return
    fi

    echo "Available Pods:"
    IFS=' ' read -r -a pod_array <<< "$pods"
    for i in "${!pod_array[@]}"; do
        echo "$((i + 1)). ${pod_array[i]}"
    done

    read -p "Enter the pod number to describe: " pod_choice
    if [[ "$pod_choice" =~ ^[0-9]+$ ]] && [ "$pod_choice" -ge 1 ] && [ "$pod_choice" -le "${#pod_array[@]}" ]; then
        kubectl describe pod "${pod_array[$((pod_choice - 1))]}" -n "$namespace"
    else
        echo "Invalid choice. Please try again."
    fi
}

# Function to login to a pod
login_to_pod() {
    local namespace=$1
    echo "Listing pods in namespace '$namespace'..."
    pods=$(kubectl get pods -n "$namespace" -o jsonpath='{.items[*].metadata.name}')

    if [ -z "$pods" ]; then
        echo "No pods found in namespace '$namespace'."
        return
    fi

    echo "Available Pods:"
    IFS=' ' read -r -a pod_array <<< "$pods"
    for i in "${!pod_array[@]}"; do
        echo "$((i + 1)). ${pod_array[i]}"
    done

    read -p "Enter the pod number to login: " pod_choice
    if [[ "$pod_choice" =~ ^[0-9]+$ ]] && [ "$pod_choice" -ge 1 ] && [ "$pod_choice" -le "${#pod_array[@]}" ]; then
        read -p "Enter the command to execute (default is /bin/sh): " exec_command
        exec_command=${exec_command:-/bin/sh}
        kubectl exec -it "${pod_array[$((pod_choice - 1))]}" -n "$namespace" -- "$exec_command"
    else
        echo "Invalid choice. Please try again."
    fi
}

# Function to check logs of a pod
check_logs() {
    local namespace=$1
    echo "Listing pods in namespace '$namespace'..."
    pods=$(kubectl get pods -n "$namespace" -o jsonpath='{.items[*].metadata.name}')

    if [ -z "$pods" ]; then
        echo "No pods found in namespace '$namespace'."
        return
    fi

    echo "Available Pods:"
    IFS=' ' read -r -a pod_array <<< "$pods"
    for i in "${!pod_array[@]}"; do
        echo "$((i + 1)). ${pod_array[i]}"
    done

    read -p "Enter the pod number to check logs: " pod_choice
    if [[ "$pod_choice" =~ ^[0-9]+$ ]] && [ "$pod_choice" -ge 1 ] && [ "$pod_choice" -le "${#pod_array[@]}" ]; then
        kubectl logs "${pod_array[$((pod_choice - 1))]}" -n "$namespace"
    else
        echo "Invalid choice. Please try again."
    fi
}

# Function to summarize access to pods in the current cluster
summarize_access() {
    local namespace=$1
    pods=$(kubectl get pods -n "$namespace" -o jsonpath='{.items[*].metadata.name}')
    accessible_pods=()
    inaccessible_pods=()

    if [ -z "$pods" ]; then
        echo "No pods found in namespace '$namespace'."
        return
    fi

    IFS=' ' read -r -a pod_array <<< "$pods"
    for pod in "${pod_array[@]}"; do
        kubectl exec -it "$pod" -n "$namespace" -- /bin/sh -c "exit" 2>/dev/null
        if [ $? -eq 0 ]; then
            accessible_pods+=("$pod")
        else
            inaccessible_pods+=("$pod")
        fi
    done

    echo -e "\nSummary of Pod Access:"
    printf "%-30s %-15s\n" "Pod Name" "Access Status"
    printf "%-30s %-15s\n" "---------" "-------------"

    for pod in "${accessible_pods[@]}"; do
        printf "%-30s %-15s\n" "$pod" "Accessible"
    done
    for pod in "${inaccessible_pods[@]}"; do
        printf "%-30s %-15s\n" "$pod" "Inaccessible"
    done
}

# Function to list daemonsets
list_daemonsets() {
    local namespace=$1
    echo "Listing daemonsets in namespace '$namespace'..."
    kubectl get daemonsets -n "$namespace"
}

# Function to list deployments
list_deployments() {
    local namespace=$1
    echo "Listing deployments in namespace '$namespace'..."
    kubectl get deployments -n "$namespace"
}

# Function to list ingresses
list_ingresses() {
    local namespace=$1
    echo "Listing ingresses in namespace '$namespace'..."
    kubectl get ingresses -n "$namespace"
}

# Function to list services
list_services() {
    local namespace=$1
    echo "Listing services in namespace '$namespace'..."
    kubectl get services -n "$namespace"
}

# Function to list config maps
list_config_maps() {
    local namespace=$1
    echo "Listing config maps in namespace '$namespace'..."
    kubectl get configmaps -n "$namespace"
}

# Function to list custom resource definitions (CRDs)
list_crds() {
    echo "Listing custom resource definitions (CRDs)..."
    kubectl get crds
}

# Function to list jobs
list_jobs() {
    local namespace=$1
    echo "Listing jobs in namespace '$namespace'..."
    kubectl get jobs -n "$namespace"
}

# Function to list persistent volumes (PVs)
list_pvs() {
    echo "Listing persistent volumes (PVs)..."
    kubectl get pv
}

# Function to list persistent volume claims (PVCs)
list_pvcs() {
    local namespace=$1
    echo "Listing persistent volume claims (PVCs) in namespace '$namespace'..."
    kubectl get pvc -n "$namespace"
}

# Function to list resource quotas
list_resource_quotas() {
    local namespace=$1
    echo "Listing resource quotas in namespace '$namespace'..."
    kubectl get resourcequotas -n "$namespace"
}

# Function to list replica sets
list_replica_sets() {
    local namespace=$1
    echo "Listing replica sets in namespace '$namespace'..."
    kubectl get replicasets -n "$namespace"
}

# Function to list service accounts
list_service_accounts() {
    local namespace=$1
    echo "Listing service accounts in namespace '$namespace'..."
    kubectl get serviceaccounts -n "$namespace"
}

# Function to list stateful sets
list_stateful_sets() {
    local namespace=$1
    echo "Listing stateful sets in namespace '$namespace'..."
    kubectl get statefulsets -n "$namespace"
}

# Function to edit a resource
edit_resource() {
    local resource_type=$1
    local namespace=$2
    echo "Listing $resource_type in namespace '$namespace'..."
    resources=$(kubectl get "$resource_type" -n "$namespace" -o jsonpath='{.items[*].metadata.name}')

    if [ -z "$resources" ]; then
        echo "No $resource_type found in namespace '$namespace'."
        return
    fi

    echo "Available $resource_type:"
    IFS=' ' read -r -a resource_array <<< "$resources"
    for i in "${!resource_array[@]}"; do
        echo "$((i + 1)). ${resource_array[i]}"
    done

    read -p "Enter the number of the $resource_type to edit: " resource_choice
    if [[ "$resource_choice" =~ ^[0-9]+$ ]] && [ "$resource_choice" -ge 1 ] && [ "$resource_choice" -le "${#resource_array[@]}" ]; then
        kubectl edit "$resource_type" "${resource_array[$((resource_choice - 1))]}" -n "$namespace"
    else
        echo "Invalid choice. Please try again."
    fi
}

# Main menu loop
while true; do
    echo -e "\nMenu:"
    echo "1. List clusters"
    echo "2. Change to a cluster"
    echo "3. List pods in the current cluster"
    echo "4. Describe a pod in the current cluster"
    echo "5. Login to a pod in the current cluster"
    echo "6. Check logs of a pod in the current cluster"
    echo "7. Summarize pod access"
    echo "8. List daemonsets in the current cluster"
    echo "9. List deployments in the current cluster"
    echo "10. List ingresses in the current cluster"
    echo "11. List services in the current cluster"
    echo "12. List config maps in the current cluster"
    echo "13. List CRDs"
    echo "14. List jobs in the current cluster"
    echo "15. List persistent volumes"
    echo "16. List PVCs in the current cluster"
    echo "17. List resource quotas in the current cluster"
    echo "18. List replica sets in the current cluster"
    echo "19. List service accounts in the current cluster"
    echo "20. List stateful sets in the current cluster"
    echo "21. Edit a pod in the current cluster"
    echo "22. Edit a service in the current cluster"
    echo "23. Edit an ingress in the current cluster"
    echo "24. Edit a deployment in the current cluster"
    echo "25. Exit"
    read -p "Select an option [1-25]: " option

    case $option in
        1)
            echo -e "\nAvailable Clusters:"
            printf "%-5s %-40s %-20s\n" "#" "Cluster Name" "Namespace"
            printf "%-5s %-40s %-20s\n" "---" "------------" "---------"
            index=1
            for cluster in "${!CLUSTERS_NAMESPACES[@]}"; do
                if [[ "$cluster" == "$current_cluster" ]]; then
                    printf "%-5s %-40s %-20s\n" "$index)" "$cluster *" "${CLUSTERS_NAMESPACES[$cluster]}"
                else
                    printf "%-5s %-40s %-20s\n" "$index)" "$cluster" "${CLUSTERS_NAMESPACES[$cluster]}"
                fi
                ((index++))
            done
            echo
            ;;
        2)
            echo "Available Clusters:"
            index=1
            for cluster in "${!CLUSTERS_NAMESPACES[@]}"; do
                echo "$index) $cluster"
                ((index++))
            done

            read -p "Select a cluster number to switch: " cluster_choice
            if [[ "$cluster_choice" =~ ^[0-9]+$ ]] && [ "$cluster_choice" -ge 1 ] && [ "$cluster_choice" -lt "$index" ]; then
                cluster_name=$(echo "${!CLUSTERS_NAMESPACES[@]}" | cut -d' ' -f"$cluster_choice")
                switch_context "$cluster_name"
            else
                echo "Invalid choice. Please try again."
            fi
            ;;
        3)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_pods "$namespace"
            fi
            ;;
        4)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                describe_pod "$namespace"
            fi
            ;;
        5)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                login_to_pod "$namespace"
            fi
            ;;
        6)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                check_logs "$namespace"
            fi
            ;;
        7)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                summarize_access "$namespace"
            fi
            ;;
        8)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_daemonsets "$namespace"
            fi
            ;;
        9)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_deployments "$namespace"
            fi
            ;;
        10)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_ingresses "$namespace"
            fi
            ;;
        11)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_services "$namespace"
            fi
            ;;
        12)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_config_maps "$namespace"
            fi
            ;;
        13)
            list_crds
            ;;
        14)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_jobs "$namespace"
            fi
            ;;
        15)
            list_pvs
            ;;
        16)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_pvcs "$namespace"
            fi
            ;;
        17)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_resource_quotas "$namespace"
            fi
            ;;
        18)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_replica_sets "$namespace"
            fi
            ;;
        19)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_service_accounts "$namespace"
            fi
            ;;
        20)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                list_stateful_sets "$namespace"
            fi
            ;;
        21)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                edit_resource "pod" "$namespace"
            fi
            ;;
        22)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                edit_resource "service" "$namespace"
            fi
            ;;
        23)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                edit_resource "ingress" "$namespace"
            fi
            ;;
        24)
            if [ -z "$current_cluster" ]; then
                echo "No cluster selected. Please select a cluster first."
            else
                namespace="${CLUSTERS_NAMESPACES[$current_cluster]}"
                edit_resource "deployment" "$namespace"
            fi
            ;;
        25)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
