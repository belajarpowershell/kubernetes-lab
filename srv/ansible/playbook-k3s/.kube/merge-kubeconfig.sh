#!/bin/sh

# Define the directory where kubeconfig files are stored
kubeconfig_dir=~/.kube/clusters

# Find all kubeconfig files in the specified directory
kubeconfig_files=$(find $kubeconfig_dir -name "*.yaml" -exec echo -n "{}:" \;)

# Remove the trailing colon
kubeconfig_files=${kubeconfig_files%:}

# Set the KUBECONFIG environment variable
export KUBECONFIG=$kubeconfig_files

# Define the target kubeconfig file
merged_kubeconfig=$kubeconfig_dir/merged-kubeconfig.yml

# Merge kubeconfig files into one
kubectl config view --raw > $merged_kubeconfig

# Update the KUBECONFIG environment variable
export KUBECONFIG=$merged_kubeconfig

echo "Merged kubeconfig files successfully. KUBECONFIG environment variable updated."
