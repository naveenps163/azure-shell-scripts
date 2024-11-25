#!/bin/bash

# Array of subscription IDs
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

# Loop through each subscription
for subscription_id in "${subscriptions[@]}"; do
    echo "Processing subscription: $subscription_id"

    # Set the subscription
    if ! az account set --subscription "$subscription_id"; then
        echo "Failed to set subscription $subscription_id. Please check the subscription ID."
        continue
    fi

    # List SQL servers and extract names
    sql_servers=$(az sql server list --query "[].{Name:name}" -o tsv)

    # Count the number of SQL servers
    sql_server_count=$(echo "$sql_servers" | wc -l)

    # Output the number of SQL servers and their names
    echo "Number of SQL Servers in $subscription_id: $sql_server_count"
    if [ $sql_server_count -gt 0 ]; then
        echo "List of SQL Servers in $subscription_id:"
        echo "$sql_servers" | column -t
    else
        echo "No SQL Servers found in $subscription_id."
    fi
    echo
done
