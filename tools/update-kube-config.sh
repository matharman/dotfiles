#!/bin/bash

# Optional: specify a region
REGION="us-east-1"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --region) REGION="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

# List all EKS clusters
CLUSTERS=$(aws eks list-clusters --region $REGION --output text --query 'clusters[*]')

echo "Clusters: $CLUSTERS"

# Loop through and update kubeconfig for each
for CLUSTER in $CLUSTERS; do
  echo "Updating kubeconfig for cluster: $CLUSTER"
  aws eks update-kubeconfig --region $REGION --name "$CLUSTER" --alias "$CLUSTER"
done