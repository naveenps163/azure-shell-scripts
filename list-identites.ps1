# Connect to Azure
Connect-AzAccount

# Define the resource group
$resourceGroupName = "rg-eunes-bsn0018415-01"

# Get managed identities
$identities = Get-AzUserAssignedIdentity -ResourceGroupName $resourceGroupName

if ($identities.Count -eq 0) {
    Write-Host "No managed identities found in resource group: $resourceGroupName"
} else {
    Write-Host "Managed identities in resource group $resourceGroupName:"
    $identities | ForEach-Object { $_.Name }
}
