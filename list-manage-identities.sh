#!/bin/bash

# Define your list of resource groups
resource_groups=(
    "rg-euned-bsn0013139-01"
    "rg-eunes-bsn0018415-01"
    "rg-euneu-bsn0018416-01"
    "rg-euner-bsn0018417-01"
    "rg-eunep-bsn0018414-01"
    "rg-euwep-bsn0018414-01"
    "rg-apass-bsn0018649-01"
    "rg-apasu-bsn0018648-01"
    "rg-apasr-bsn0018647-01"
    "rg-apasp-bsn0018859-01"
    "rg-lau2s-bsn0018646-01"
    "rg-lau2u-bsn0018645-01"
    "rg-lau2r-bsn0018644-01"
    "rg-lau2p-bsn0018858-01"
    "rg-laucp-bsn0018858-01"
    "rg-nau2s-bsn0018863-01"
    "rg-nau2u-bsn0018862-01"
    "rg-nau2r-bsn0018861-01"
    "rg-nau2p-bsn0018857-01"
    "rg-naucp-bsn0018857-01"
)

# Loop through each resource group
for rg in "${resource_groups[@]}"; do
    echo "Listing managed identities in resource group: $rg"
    
    # List managed identities in the current resource group
    az identity list --resource-group "$rg" --output table
    
    # Add a separator for readability
    echo "---------------------------------------"
done
