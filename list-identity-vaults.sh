#!/bin/bash

# List of resource groups
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
    echo "Resource Group: $rg"
    
    # Check if the resource group exists
    if az group exists --name "$rg"; then
        # List Managed Identities
        echo "Managed Identities:"
        managed_identities=$(az identity list --resource-group "$rg" --query "[].{Name:name}" -o table)
        
        if [ -z "$managed_identities" ]; then
            echo "  No Managed Identities found."
        else
            echo "$managed_identities"
        fi
    else
        echo "  Resource Group does not exist or access denied."
    fi

    echo  # Add a blank line for readability
done
