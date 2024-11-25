#!/bin/bash

# Ensure the Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "Azure CLI not found. Please install Azure CLI to run this script."
    exit 1
fi

# Log in to Azure (interactive login or use a service principal for automation)
echo "Logging in to Azure..."
az login

# Set your Azure subscription ID
subscription_id="sub-eune-dev01"  # Replace with your actual subscription ID
az account set --subscription "$subscription_id"

# Get the list of Azure SQL databases
echo "Fetching the list of Azure SQL databases..."
databases=$(az sql db list --query "[].{Name:name}" -o tsv)

# Count the number of databases
db_count=$(echo "$databases" | wc -l)

# Print the number of Azure SQL databases
echo "Number of Azure SQL databases: $db_count"
