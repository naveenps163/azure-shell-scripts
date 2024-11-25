#!/bin/bash

# Check if user is logged in to Azure
if ! az account show > /dev/null 2>&1; then
    echo "You are not logged in to Azure. Please run 'az login'."
    exit 1
fi

# Fetch and list Azure SQL Servers
echo "Listing Azure SQL Servers:"
az sql server list --query "[].{Name:name, ResourceGroup:resourceGroup, Location:location}" --output table
