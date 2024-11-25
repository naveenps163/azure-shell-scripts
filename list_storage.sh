#!/bin/bash

# Ensure Azure CLI is logged in
#az login --only-show-errors > /dev/null

# List all storage accounts and print them in table format
az storage account list --query "[].{Name:name, ResourceGroup:resourceGroup, Location:location, SKU:sku.name, Kind:kind}" --output table
