#!/bin/bash

# Get the list of cluster contexts
clusters=$(kubectl config get-contexts -o name)

# Initialize an array to store inaccessible pods
not_accessible_pods=()

# Loop through each cluster
for cluster in $clusters; do
    echo -e "\nChecking pods in cluster: $cluster..."
    
    # Set the current context
    kubectl config use-context "$cluster" 2>/dev/null
    
    if [ $? -ne 0 ]; then
        echo "Error: Unable to switch to context $cluster"
        continue
    fi

    # Get the list of pods
    pods=$(kubectl get pods --no-headers | awk '{print $1}')

    if [ -z "$pods" ]; then
        echo "No pods found in cluster $cluster."
        continue
    fi

    echo "Pods in cluster $cluster:"
    echo "$pods"

    for pod in $pods; do
        echo "Trying to log in to pod $pod in cluster $cluster..."
        
        # Attempt to log in to the pod
        kubectl exec -it "$pod" -- /bin/bash -c "exit" 2>/dev/null
        
        if [ $? -ne 0 ]; then
            echo "Failed to access pod $pod in cluster $cluster"
            not_accessible_pods+=("$cluster: $pod")
        else
            echo "Successfully accessed pod $pod in cluster $cluster"
        fi
    done
done

# Display inaccessible pods
if [ ${#not_accessible_pods[@]} -gt 0 ]; then
    echo -e "\nPods You Are Not Able to Access:"
    for entry in "${not_accessible_pods[@]}"; do
        echo "$entry"
    done
else
    echo -e "\nYou Are Able to Access All Pods in All Clusters."
fi
