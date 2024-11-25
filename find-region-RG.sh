#!/bin/bash

# Check if a resource group name is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <resource-group-name>"
    exit 1
fi

RESOURCE_GROUP_NAME=$1

# Fetch the region of the specified resource group
REGION=$(az group show --name "$RESOURCE_GROUP_NAME" --query location --output tsv)

# Check if the command succeeded
if [ $? -ne 0 ]; then
    echo "Error: Resource group '$RESOURCE_GROUP_NAME' not found or unable to retrieve information."
    exit 1
fi

# Output the region
echo "Resource Group '$RESOURCE_GROUP_NAME' is located in region: $REGION"
