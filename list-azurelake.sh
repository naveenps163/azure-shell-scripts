#!/bin/bash

# Log in to Azure (uncomment if you need to log in interactively)
# az login

# Set the desired subscription (optional)
# az account set --subscription "Your Subscription Name"

# List Azure Data Lake Storage accounts
lake_accounts=$(az storage account list --query "[?kind=='StorageV2'].{Name:name}" -o tsv)

# Count the number of Data Lake Storage accounts
count=$(echo "$lake_accounts" | wc -l)

# Output the names and count
echo "Number of Azure Data Lake Storage accounts: $count"
if [ $count -gt 0 ]; then
    echo "Names of Azure Data Lake Storage accounts:"
    echo "$lake_accounts"
else
    echo "No Azure Data Lake Storage accounts found."
fi
