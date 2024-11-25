#!/bin/bash

# Ensure you're logged in to Azure CLI
#az login --only-show-errors > /dev/null

# Fetch the list of DNS zones and count them
dns_zones_count=$(az network dns zone list --query "length([])" -o tsv)

# Output the number of DNS zones
echo "Number of DNS zones in your Azure subscription: $dns_zones_count"
