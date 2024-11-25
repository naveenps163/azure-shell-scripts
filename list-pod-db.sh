#!/bin/bash

# Define the specific namespace
NAMESPACE="radarlive-sit"

echo "Checking namespace: $NAMESPACE"

# Get all pods in the namespace
PODS=$(kubectl get pods -n "$NAMESPACE" -o jsonpath='{.items[*].metadata.name}')

# Loop through each pod
for POD in $PODS; do
  echo "  Pod: $POD"

  # Describe the pod and look for environment variables related to the database
  DB_INFO=$(kubectl describe pod "$POD" -n "$NAMESPACE" | grep -E 'DATABASE_URL|DB_HOST|DB_PORT|DB_NAME')

  if [ -n "$DB_INFO" ]; then
    echo "    Database connection details:"
    echo "$DB_INFO"
  else
    echo "    No database connection details found."
  fi
done
