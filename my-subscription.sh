#!/bin/bash

# Ensure you're logged in to Azure CLI
#az login --only-show-errors > /dev/null

# Fetch the current subscription details
current_subscription=$(az account show --query "{Name:name, SubscriptionId:id}" -o table)

# Output the current subscription details
echo "Current Azure Subscription:"
echo "$current_subscription"
