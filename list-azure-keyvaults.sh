#!/bin/bash

# Check if Azure CLI is installed
if ! command -v az &> /dev/null
then
    echo "Azure CLI could not be found. Please install it."
    exit 1
fi

# Log in to Azure (uncomment the following line if you need to log in)
# az login

# List all Azure subscriptions and save them in an array
echo "Listing all Azure subscriptions..."
subscriptions=($(az account list --query "[].{Name:name, ID:id}" -o tsv))

# Display subscriptions with an index
echo "Available subscriptions:"
for i in "${!subscriptions[@]}"; do
    echo "$((i + 1)). ${subscriptions[i]}"
done

# Prompt for subscription index
read -p "Enter the subscription number: " subscription_index

# Validate input
if [[ "$subscription_index" -lt 1 || "$subscription_index" -gt "${#subscriptions[@]}" ]]; then
    echo "Invalid selection. Please run the script again."
    exit 1
fi

# Extract the selected subscription ID
subscription_id=$(echo "${subscriptions[$((subscription_index - 1))]}" | awk '{print $2}')

# Switch to the selected subscription
az account set --subscription "$subscription_id"
echo "Switched to subscription: ${subscriptions[$((subscription_index - 1))]}"

# List all Key Vaults in the current subscription
echo "Listing all Key Vaults in the current subscription..."
az keyvault list --query "[].{Name:name, ResourceGroup:resourceGroup}" -o table
