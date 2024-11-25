# Get the list of cluster contexts
$clusters = kubectl config get-contexts --output name

# Initialize arrays for accessible and inaccessible clusters
$accessibleClusters = @()
$notAccessibleClusters = @{}

# Loop through each cluster
foreach ($cluster in $clusters) {
    Write-Host "Checking pods in cluster: $($cluster)..."

    # Set the current context
    kubectl config use-context $cluster | Out-Null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Unable to switch to context $cluster"
        continue
    }

    # Get the list of pods
    $pods = kubectl get pods --no-headers | ForEach-Object { $_.Split()[0] }

    if (-not $pods) {
        Write-Host "No pods found in cluster $cluster."
        continue
    }

    Write-Host "Pods in cluster $($cluster):"
    $pods | ForEach-Object { Write-Host $_ }

    $accessiblePodsCount = 0

    foreach ($pod in $pods) {
        Write-Host "Trying to log in to pod $($pod) in cluster $($cluster)..."

        # Attempt to log in to the pod
        $result = kubectl exec -it $pod -- /bin/bash -c "exit" 2>$null

        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to access pod $($pod) in cluster $($cluster)"
            if (-not $notAccessibleClusters.ContainsKey($cluster)) {
                $notAccessibleClusters[$cluster] = @()
            }
            $notAccessibleClusters[$cluster] += $pod
        } else {
            Write-Host "Successfully accessed pod $($pod) in cluster $($cluster)"
            $accessiblePodsCount++
        }
    }

    # If at least one pod is accessible, add the cluster to accessible clusters
    if ($accessiblePodsCount -gt 0) {
        $accessibleClusters += $cluster
    }
}

# Display results in table format
Write-Host "`nSummary of Cluster Access:"
$table = @()

foreach ($cluster in $clusters) {
    $table += [PSCustomObject]@{
        Cluster         = $cluster
        Accessible      = if ($accessibleClusters -contains $cluster) { "Yes" } else { "No" }
        NotAccessiblePods = if ($notAccessibleClusters.ContainsKey($cluster)) {
            ($notAccessibleClusters[$cluster] -join ', ')
        } else {
            "N/A"
        }
    }
}

$table | Format-Table -AutoSize
