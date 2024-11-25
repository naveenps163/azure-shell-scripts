#!/bin/bash

# Check if Azure CLI is installed
if ! command -v az &> /dev/null
then
    echo "Azure CLI could not be found. Please install it."
    exit 1
fi

# Log in to Azure (uncomment if necessary)
# az login

echo "Listing Managed Identities and Workload Identities in Azure..."

# List System-Assigned Managed Identities
echo -e "\nSystem-Assigned Managed Identities:"
az resource list --resource-type "Microsoft.ManagedIdentity/userAssignedIdentities" --query "[?identityType=='SystemAssigned'].{Name:name, ResourceGroup:resourceGroup}" -o table

# List User-Assigned Managed Identities
echo -e "\nUser-Assigned Managed Identities:"
az resource list --resource-type "Microsoft.ManagedIdentity/userAssignedIdentities" --query "[?identityType=='UserAssigned'].{Name:name, ResourceGroup:resourceGroup}" -o table

# List Workload Identities (Note: Workload identities are typically tied to Azure AD App Registrations)
echo -e "\nWorkload Identities (Azure AD App Registrations):"
az ad sp list --query "[].{Name:displayName, AppId:appId}" -o table

echo "Listing completed."
