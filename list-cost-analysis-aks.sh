#!/bin/bash

# Define an associative array with subscriptions and corresponding resource groups
declare -A subscriptions
subscriptions=(
    ["sub-eune-sit01"]="rg-eunes-bsn0018415-01"
    ["sub-eune-uat01"]="rg-euneu-bsn0018416-01"
    ["sub-eune-preprod01"]="rg-euner-bsn0018417-01"
    ["sub-eune-prod01"]="rg-eunep-bsn0018414-01"
    ["sub-euwe-prod01"]="rg-euwep-bsn0018414-01"
    ["sub-apas-sit01"]="rg-apass-bsn0018649-01"
    ["sub-apas-uat01"]="rg-apasu-bsn0018648-01"
    ["sub-apas-preprod01"]="rg-apasr-bsn0018647-01"
    ["sub-apas-prod01"]="rg-apasp-bsn0018859-01"
    ["sub-lau2-sit01"]="rg-lau2s-bsn0018646-01"
    ["sub-lau2-uat01"]="rg-lau2u-bsn0018645-01"
    ["sub-lau2-preprod01"]="rg-lau2r-bsn0018644-01"
    ["sub-lau2-prod01"]="rg-lau2p-bsn0018858-01"
    ["sub-lauc-prod01"]="rg-laucp-bsn0018858-01"
    ["sub-nau2-sit01"]="rg-nau2s-bsn0018863-01"
    ["sub-nau2-uat01"]="rg-nau2u-bsn0018862-01"
    ["sub-nau2-preprod01"]="rg-nau2r-bsn0018861-01"
    ["sub-nau2-prod01"]="rg-nau2p-bsn0018857-01"
    ["sub-nauc-prod01"]="rg-naucp-bsn0018857-01"
)

# Loop through each subscription and associated resource group
for subscription in "${!subscriptions[@]}"; do
    # Set the Azure subscription context
    echo "Switching to subscription: $subscription"
    az account set --subscription "$subscription" || { echo "Failed to set subscription $subscription"; exit 1; }

    # Get the resource group associated with the current subscription
    resource_group="${subscriptions[$subscription]}"

    # Fetch the cost data for the resource group in the current subscription
    echo "Fetching cost for resource group: $resource_group in subscription: $subscription"

    # Query the Azure Consumption API for the current month's usage cost
    cost_data=$(az consumption usage list --resource-group "$resource_group" --query "[?billingPeriodStart ge '$(date +%Y-%m-01')]" --output json)

    # Check if any cost data is returned
    if [[ "$cost_data" != "[]" ]]; then
        # Extract the resource group and cost from the JSON output
        resource_group_cost=$(echo "$cost_data" | grep -oP '"ResourceGroup":"\K[^"]+')
        cost=$(echo "$cost_data" | grep -oP '"pretaxCost":\K[0-9.]+')
        
        # Output the results
        echo "Resource Group: $resource_group_cost, Cost: $cost"
    else
        echo "No cost data found for resource group: $resource_group"
    fi

    echo "--------------------------------------"
done
