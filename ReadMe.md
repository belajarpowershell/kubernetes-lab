# Kubernetes Lab Setup

This repository contains the relevant steps to setup 2  Lightweight Kubernetes ( k3s) a single node and a High Available Cluster.

The objective of this lab is to be able to rebuild the clusters very quickly as this is for testing services and applications. 

Files required for the setup can be extracted from the git repository  https://github.com/belajarpowershell/kubernetes-lab

Follow the sequence number in the files , this will ensure that all the required services are setup.



Here is a high level on the tasks required .

- Clone the repository to the Hyper V host. (step `003-clone-repository`)
- Create the Virtual machines required using the PowerShell script. ( step `004-Hyper-V-VM-creation` )
- Setup Alpine Linux on VM `alpine1` .(step `100-alpine1-setup`)
- Connect to `alpine1` via ssh (step `101-ssh-to-alpine1` )
- Clone the repository on `alpine1` ( step 102-Clone-repository)
- Setup on `alpine1` the various services required . (step `103-setup-using-ansible`)
- Install Ubuntu OS on the remaining Virtual Machines ( loadbalancer,master1/2/3,worker1/2/3,singlenode) (step`113-generate-user-data-multipleVM` )
- 
