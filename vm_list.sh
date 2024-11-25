#!/bin/bash

# Array of subscription IDs
subscription_ids=(
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

# Log in to Azure (you may need to do this manually or configure service principal authentication)
#az login

for subscription_id in "${subscription_ids[@]}"; do
    # Set the subscription
    az account set --subscription "$subscription_id"

    # List VMs and count them
    vm_count=$(az vm list --query "length([])" -o tsv)
    
    # Output the subscription ID and the number of VMs
    echo "Subscription: $subscription_id"
    echo "Number of VMs: $vm_count"
    echo ""
done
