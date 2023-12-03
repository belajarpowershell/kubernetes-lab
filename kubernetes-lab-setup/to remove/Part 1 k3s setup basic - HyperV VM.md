# k3s setup basic 


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
View the video on how the HyperV VM's are created.
