#!/bin/bash

# Ensure Azure CLI is logged in
#az login --only-show-errors > /dev/null

# List all Azure regions and print them in table format
az account list-locations --query "[].{Region:name}" --output table
