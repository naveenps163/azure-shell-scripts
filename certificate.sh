#!/bin/bash

# Ensure you're logged in to Azure CLI
#az login --only-show-errors > /dev/null

# List all Key Vaults in the subscription
key_vaults=$(az keyvault list --query "[].name" -o tsv)

# Initialize a counter for certificates
total_certificates=0

# Loop through each Key Vault and count the certificates
for vault in $key_vaults; do
    # List certificates in the current Key Vault
    certificates_count=$(az keyvault certificate list --vault-name "$vault" --query "length([])" -o tsv)
    total_certificates=$((total_certificates + certificates_count))
done

# Output the total number of certificates
echo "Total number of certificates in your Azure subscription: $total_certificates"
