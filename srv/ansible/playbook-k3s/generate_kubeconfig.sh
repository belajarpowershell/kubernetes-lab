#!/bin/ash

# Define the directory containing context files
clusters_dir=~/.kube/clusters

# Define the destination kubeconfig file
kubeconfig_dest=~/.kube/config

# Check if clusters directory exists
if [ ! -d "$clusters_dir" ]; then
    echo "Error: Clusters directory does not exist: $clusters_dir"
    exit 1
fi

# Start with an empty kubeconfig
echo -n > "$kubeconfig_dest"

# Loop through context files in the clusters directory
for ctx_file in "$clusters_dir"/*; do
    if [ -f "$ctx_file" ]; then
        # Append the context to the kubeconfig
        KUBECONFIG="$ctx_file:$kubeconfig_dest" kubectl config view --merge --flatten >> "$kubeconfig_dest"
    fi
done

echo "Kubeconfig file generated at: $kubeconfig_dest"
