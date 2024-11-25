#!/bin/bash

# List of specific subscriptions
subscriptions=(
    "sub-eune-dev01"
    "sub-eune-sit01"
    "sub-eune-uat01"
    "sub-eune-preprod01"
    "sub-eune-prod01"
    "sub-euwe-prod01"
    "sub-apas-sit01"
    "sub-apas-uat01"
    "sub-apas-preprod01"
    "sub-apas-prod01"
    "sub-lau2-sit01"
    "sub-lau2-uat01"
    "sub-lau2-preprod01"
    "sub-lau2-prod01"
    "sub-lauc-prod01"
    "sub-nau2-sit01"
    "sub-nau2-uat01"
    "sub-nau2-prod01"
    "sub-nauc-prod01"
)

# Loop through each subscription and list security groups
echo "Network Security Groups by Subscription:"
echo "-----------------------------------------"

for sub in "${subscriptions[@]}"; do
    echo "Subscription: $sub"
    nsgs=$(az network nsg list --subscription "$sub" --query "[].{Name:name}" -o table)
    
    if [ -z "$nsgs" ]; then
        echo "No NSGs found."
    else
        echo "$nsgs"
    fi
    echo ""
done
