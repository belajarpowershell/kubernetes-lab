sh-keyscan "$server" >> ~/.ssh/known_hosts!/bin/sh
apk add sshpass
#prompt to enter passowrd
read -s -p "Enter password: " PASSWORD
echo ""

# SSH key file
ssh_key="/root/.ssh/ubuntu-k3s-sshkey.pub"

# Loop through each server
cat /dev/null > ~/.ssh/known_hosts
for server in loadbalancer master1 master2 master3 worker1 worker2 worker3 xsinglenode
do
    # Perform ssh-keyscan to gather SSH host key
    echo $server

     ssh-keyscan -H "$server" >> ~/.ssh/known_hosts

    # Copy SSH public key to the server
    sshpass -p $PASSWORD ssh-copy-id -i $ssh_key ubuntu@$server
done



