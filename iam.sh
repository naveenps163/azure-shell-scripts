#!/bin/bash

# Ensure Azure CLI is logged in
#az login --only-show-errors > /dev/null

# List all Azure AD users and print them in table format
az ad user list --query "[].{UserPrincipalName:userPrincipalName, DisplayName:displayName, ObjectId:objectId, UserType:userType}" --output table
