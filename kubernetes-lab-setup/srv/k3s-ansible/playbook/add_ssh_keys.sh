#!/bin/bash

# Reset and add SSH host keys to known_hosts file

# Clear the existing known_hosts file
> ~/.ssh/known_hosts

# Define the list of hosts
hosts=("master1" "master2" "master3" "worker1" "worker2" "worker3" "single" "loadbalancer")

# Loop through each host and append the SSH host key to known_hosts
for host in "${hosts[@]}"; do
    ssh-keyscan -4 "$host" >> ~/.ssh/known_hosts
done

echo "SSH host keys added to ~/.ssh/known_hosts"

echo " copy public key to remote server"
# Define the path to your public key
public_key="/root/.ssh/id_ed25519.pub"

# enable ssh agent

# Check if the SSH agent is running
if [ -z "$SSH_AGENT_PID" ] || ! ps -p "$SSH_AGENT_PID" > /dev/null; then
    echo "Starting SSH agent..."
    eval `ssh-agent -s`
else
    echo "SSH agent is already running (PID: $SSH_AGENT_PID)."
fi

# Check if the SSH key is added
if ssh-add -L | grep -qF "$(cat /root/.ssh/id_ed25519.pub)"; then
    echo "SSH key is already added."
else
    echo "Adding SSH key..."
    ssh-add /root/.ssh/id_ed25519
fi


# Loop through each host and check if the key is already present
for host in "${hosts[@]}"; do
    # Check if the public key is not present in the authorized_keys file
    if ! ssh "ubuntu@$host" "grep -qF '$(cat $public_key)' ~/.ssh/authorized_keys"; then
        # Copy the public key
        ssh-copy-id -i "$public_key" "ubuntu@$host"
    else
        echo "Key already exists for $host"
    fi
done

# For loadbalancer as root
if ! ssh "root@loadbalancer" "grep -qF '$(cat $public_key)' /root/.ssh/authorized_keys"; then
    ssh-copy-id -i "$public_key" "root@loadbalancer"
else
    echo "Key already exists for loadbalancer"
fi
