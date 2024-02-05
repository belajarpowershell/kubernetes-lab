#kill all ssh-agent currently running
killall ssh-agent

# check if ssh-agent is running. 
eval $(ssh-agent) 

# add the private key using ssh-add, the passphrase will be prompted and not required to manually enter 
ssh-add /root/.ssh/ubuntu-k3s-sshkey

# list keys in memory
ssh-add -l