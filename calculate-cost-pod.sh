#!/bin/bash

# Set your namespace and pricing model
NAMESPACE="$1"
COST_PER_POD=0.10      # Cost per pod
COST_PER_CPU=0.05      # Cost per CPU (per hour)
COST_PER_MEMORY=0.02   # Cost per GiB of memory (per hour)

if [ -z "$NAMESPACE" ]; then
    echo "Usage: $0 <namespace>"
    exit 1
fi

# Get the list of pods in the namespace
PODS=$(kubectl get pods -n "$NAMESPACE" --no-headers)

# Initialize cost variables
total_cost=0
pod_count=0

# Function to convert CPU and memory values to numeric values
convert_cpu() {
    local cpu=$1
    if [[ $cpu == *"m" ]]; then
        echo "$(( ${cpu%m} / 1000 ))"  # Convert milliCPU to CPU
    else
        echo "$cpu"  # Return as is
    fi
}

convert_memory() {
    local memory=$1
    if [[ $memory == *"Gi" ]]; then
        echo "$memory"  # Return as is for GiB
    elif [[ $memory == *"Mi" ]]; then
        echo "$(( ${memory%Mi} / 1024 ))"  # Convert MiB to GiB
    fi
}

# Iterate over each pod to calculate costs
while IFS= read -r pod; do
    pod_name=$(echo "$pod" | awk '{print $1}')
    resources=$(kubectl get pod "$pod_name" -n "$NAMESPACE" -o=jsonpath='{.spec.containers[*].resources}')

    # Extract resource requests/limits
    cpu_request=$(echo "$resources" | grep -oP 'requests:\s*cpu:\s*\K[^ ]+')
    mem_request=$(echo "$resources" | grep -oP 'requests:\s*memory:\s*\K[^ ]+')

    # Convert resources to numeric values
    cpu_value=$(convert_cpu "$cpu_request")
    mem_value=$(convert_memory "$mem_request")

    # Calculate pod cost
    pod_cost=$(echo "$COST_PER_POD + ($cpu_value * $COST_PER_CPU) + ($mem_value * $COST_PER_MEMORY)" | awk '{printf "%.2f", $0}')
    total_cost=$(echo "$total_cost + $pod_cost" | awk '{printf "%.2f", $0}')
    pod_count=$((pod_count + 1))
done <<< "$PODS"

echo "Total Pods in namespace '$NAMESPACE': $pod_count"
echo "Total Cost for namespace '$NAMESPACE': \$${total_cost}"
