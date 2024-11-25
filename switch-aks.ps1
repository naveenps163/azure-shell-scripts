# Define clusters and their namespaces
$clustersNamespaces = @{
    "aks-apasp-bsn0018859-01" = "radarlive-prod"
    "aks-apasr-bsn0018647-01" = "radarlive-preprod"
    "aks-apass-bsn0018649-01" = "radarlive-sit"
    "aks-apasu-bsn0018648-01" = "radarlive-uat"
    "aks-euned-bsn0013139-01" = "radarlive-dev"
    "aks-eunep-bsn0018414-01" = "radarlive-prod"
    "aks-euner-bsn0018417-01" = "radarlive-preprod"
    "aks-eunes-bsn0018415-01" = "radarlive-sit"
    "aks-euneu-bsn0018416-01" = "radarlive-uat"
    "aks-euwep-bsn0018414-01" = "radarlive-prod"
    "aks-lau2p-bsn0018858-01" = "radarlive-prod"
    "aks-lau2r-bsn0018644-01" = "radarlive-preprod"
    "aks-lau2s-bsn0018646-01" = "radarlive-sit"
    "aks-lau2u-bsn0018645-01" = "radarlive-uat"
    "aks-laucp-bsn0018858-01" = "radarlive-prod"
    "aks-nau2p-bsn0018857-01" = "radarlive-prod"
    "aks-nau2r-bsn0018861-01" = "radarlive-preprod"
    "aks-nau2s-bsn0018863-01" = "radarlive-sit"
    "aks-nau2u-bsn0018862-01" = "radarlive-uat"
    "aks-naucp-bsn0018857-01" = "radarlive-prod"
}

$currentCluster = ""

# Function to switch context
function Switch-Context {
    param (
        [string]$context
    )
    Write-Host "Switching to context: $context"
    kubectl config use-context $context

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Switched to $context successfully."
        $global:currentCluster = $context
    } else {
        Write-Host "Failed to switch to $context."
    }
}

# Function to list pods
function List-Pods {
    param (
        [string]$namespace
    )
    Write-Host "Listing pods in namespace '$namespace'..."
    kubectl get pods -n $namespace
}

# Function to log into a pod
function Login-To-Pod {
    param (
        [string]$namespace
    )
    Write-Host "Listing pods in namespace '$namespace'..."
    $pods = kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}'

    if (-not $pods) {
        Write-Host "No pods found in namespace '$namespace'."
        return
    }

    $podArray = $pods -split ' '
    for ($i = 0; $i -lt $podArray.Length; $i++) {
        Write-Host "$($i + 1). $($podArray[$i])"
    }

    $podChoice = Read-Host "Enter the pod number to login"
    if ($podChoice -as [int] -and $podChoice -ge 1 -and $podChoice -le $podArray.Length) {
        $execCommand = Read-Host "Enter the command to execute (default is /bin/sh)"
        if (-not $execCommand) { $execCommand = "/bin/sh" }
        kubectl exec -it $podArray[$podChoice - 1] -n $namespace -- $execCommand
    } else {
        Write-Host "Invalid choice. Please try again."
    }
}

# Function to check logs of a pod
function Check-Logs {
    param (
        [string]$namespace
    )
    Write-Host "Listing pods in namespace '$namespace'..."
    $pods = kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}'

    if (-not $pods) {
        Write-Host "No pods found in namespace '$namespace'."
        return
    }

    $podArray = $pods -split ' '
    for ($i = 0; $i -lt $podArray.Length; $i++) {
        Write-Host "$($i + 1). $($podArray[$i])"
    }

    $podChoice = Read-Host "Enter the pod number to check logs"
    if ($podChoice -as [int] -and $podChoice -ge 1 -and $podChoice -le $podArray.Length) {
        kubectl logs $podArray[$podChoice - 1] -n $namespace
    } else {
        Write-Host "Invalid choice. Please try again."
    }
}

# Function to summarize access to pods in the current cluster
function Summarize-Access {
    param (
        [string]$namespace
    )
    $pods = kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}'
    $accessiblePods = @()
    $inaccessiblePods = @()

    if (-not $pods) {
        Write-Host "No pods found in namespace '$namespace'."
        return
    }

    $podArray = $pods -split ' '
    foreach ($pod in $podArray) {
        kubectl exec -it $pod -n $namespace -- /bin/sh -c "exit" 2>$null
        if ($LASTEXITCODE -eq 0) {
            $accessiblePods += $pod
        } else {
            $inaccessiblePods += $pod
        }
    }

    Write-Host "`nSummary of Pod Access:"
    Write-Host ("{0,-30} {1,-15}" -f "Pod Name", "Access Status")
    Write-Host ("{0,-30} {1,-15}" -f "---------", "-------------")

    foreach ($pod in $accessiblePods) {
        Write-Host ("{0,-30} {1,-15}" -f $pod, "Accessible")
    }
    foreach ($pod in $inaccessiblePods) {
        Write-Host ("{0,-30} {1,-15}" -f $pod, "Inaccessible")
    }
}

# Main menu loop
while ($true) {
    Write-Host "`nMenu:"
    Write-Host "1. List clusters"
    Write-Host "2. Change to a cluster"
    Write-Host "3. List pods in the current cluster"
    Write-Host "4. Login to a pod in the current cluster"
    Write-Host "5. Check logs of a pod in the current cluster"
    Write-Host "6. Summarize pod access"
    Write-Host "7. Exit"
    $option = Read-Host "Select an option [1-7]"

    switch ($option) {
        1 {
            Write-Host "`nAvailable Clusters:"
            Write-Host ("{0,-5} {1,-40} {2,-20}" -f "#", "Cluster Name", "Namespace")
            Write-Host ("{0,-5} {1,-40} {2,-20}" -f "---", "------------", "---------")
            $index = 1
            foreach ($cluster in $clustersNamespaces.Keys) {
                if ($cluster -eq $currentCluster) {
                    Write-Host ("{0,-5} {1,-40} {2,-20}" -f "$index)", "$cluster *", "$($clustersNamespaces[$cluster])")
                } else {
                    Write-Host ("{0,-5} {1,-40} {2,-20}" -f "$index)", "$cluster", "$($clustersNamespaces[$cluster])")
                }
                $index++
            }
        }
        2 {
            Write-Host "Available Clusters:"
            $index = 1
            foreach ($cluster in $clustersNamespaces.Keys) {
                Write-Host "$index) $cluster"
                $index++
            }

            $clusterChoice = Read-Host "Select a cluster number to switch"
            if ($clusterChoice -as [int] -and $clusterChoice -ge 1 -and $clusterChoice -lt $index) {
                $clusterName = $clustersNamespaces.Keys[$clusterChoice - 1]
                Switch-Context $clusterName
            } else {
                Write-Host "Invalid choice. Please try again."
            }
        }
        3 {
            if (-not $currentCluster) {
                Write-Host "No cluster selected. Please select a cluster first."
            } else {
                $namespace = $clustersNamespaces[$currentCluster]
                List-Pods $namespace
            }
        }
        4 {
            if (-not $currentCluster) {
                Write-Host "No cluster selected. Please select a cluster first."
            } else {
                $namespace = $clustersNamespaces[$currentCluster]
                Login-To-Pod $namespace
            }
        }
        5 {
            if (-not $currentCluster) {
                Write-Host "No cluster selected. Please select a cluster first."
