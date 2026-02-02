sh-keyscan "$server" >> ~/.ssh/known_hosts!/bin/sh
apk add sshpass
#prompt to enter passowrd
read -s -p "Enter password: " PASSWORD
echo ""

# SSH key file
ssh_key="/root/.ssh/ubuntu-k3s-sshkey.pub"

# Loop through each server
cat /dev/null > ~/.ssh/known_hosts
for server in k3s-master k3s-01 k3s-02 k3s-03
do
    # Perform ssh-keyscan to gather SSH host key
    echo $server

     ssh-keyscan "$server" >> ~/.ssh/known_hosts

    # Copy SSH public key to the server
    sshpass -p $PASSWORD ssh-copy-id -f -i $ssh_key ubuntu@$server
done



