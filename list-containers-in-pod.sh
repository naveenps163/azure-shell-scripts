#!/bin/bash

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "kubectl not found. Please install it first."
    exit 1
fi

# Get all pods and their container names and counts
echo -e "Namespace\tPod Name\tNumber of Containers\tContainer Names"
echo "--------------------------------------------------------------------------------"
kubectl get pods -n radarlive-sit -o=jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{.spec.containers[*].name}{"\n"}{end}' | while IFS=$'\t' read -r namespace pod containers; do
    container_count=$(echo "$containers" | wc -w)
    echo -e "$namespace\t$pod\t$container_count\t$containers"
done
