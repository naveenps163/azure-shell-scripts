#!/bin/bash

# Log in to Azure
#az login

# List workload identities in table format
az identity list --query "[].{Name:name, ID:id, ResourceGroup:resourceGroup}" --output table
