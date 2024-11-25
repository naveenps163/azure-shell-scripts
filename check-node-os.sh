#!/bin/bash

# Get the list of nodes
nodes=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')

# Loop through each node and check the OS
for node in $nodes; do
    echo "Checking OS for node: $node"
    os=$(kubectl get node $node -o jsonpath='{.status.nodeInfo.osImage}')
    echo "OS Image: $os"
    echo "-----------------------"
done
