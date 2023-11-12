# k3s setup basic 

This reference is to setup k3s from a basic setup and expand with the relevant tools to make support automated.
1. Part 1 HyperV VM setup.
2. Part 2 Ubuntu Setup
3. Part 3 k3s installation.
4. Part 4 Configure management server to access k3s nodes remotely.
5. 

## Part 1.1 The HyperV VM configuration

Prequisites

| Item | requirement| additional notes |
|---|---|---|
|My Computer specs | i5-3450 CPU @ 3.10GHz with 16GB memory and 1TB Dedicated Disk  | This is an old PC upgraded for the LAB |
|Hyper V | Working knowledge of HyperV |Able to create and install Ubuntu |
|Hyper V | HyperV installed |Please refer to Micorosoft Documentation|
|Hyper V | 3 instances |1x management , 2 x single node k3s|
|HyperV management server specs| 1CPU - 2GB Ram -100GB | management node to manage k3s nodes|
|HyperV Single node specs| 1CPU - 2GB Ram -100GB + 60GB |VM to run k3s workloads|
|HyperV Configuration| Network with External access |My external Network switch is named ExternalNetwork|

To make the HyperV VM faster I have created a script
[[HyperV-mgmt-and-2X-singlenode.ps1|Powershell script to generate HyperV VM]]




![[HyperV-network-switch.png]]