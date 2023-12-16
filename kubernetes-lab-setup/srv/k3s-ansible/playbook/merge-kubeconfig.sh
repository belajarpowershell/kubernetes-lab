#!/bin/bash

KUBECONFIG_FILE_MERGED=~/.kube/config_merged
CONFIG_DIR=~/.kube/clusters   # Replace with the directory containing your kubeconfig files

# Create an empty merged kubeconfig file
> $KUBECONFIG_FILE_MERGED

# Find all YAML files in the specified directory
for file in $CONFIG_DIR/*.yaml; do
    echo "Merging $file"
    kubectl config view --merge --flatten $file > $KUBECONFIG_FILE_MERGED
done

# Verify the merged kubeconfig file
kubectl config view --minify --raw --kubeconfig=$KUBECONFIG_FILE_MERGED

# Optionally, set the merged kubeconfig as the default
export KUBECONFIG=$KUBECONFIG_FILE_MERGED
$KUBECONFIG_FILE_MERGED >config


KUBECONFIG_FILE_MERGED=~/.kube/config_merged
CONFIG_DIR=~/.kube/clusters   # Replace with the directory containing your kubeconfig files
KUBECONFIG_FILE_MERGED=~/.kube/config_merged
CONFIG_DIR=~/.kube/clusters   # Replace with the directory containing your kubeconfig files

export KUBECONFIG=$(find ~/.kube/clusters -type f | sed ':a;N;s/\n/:/;ba')