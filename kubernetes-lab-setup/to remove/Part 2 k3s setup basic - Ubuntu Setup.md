# Part 2 Ubuntu Setup

Once the HyperV VM's are created we now need to install a Linux OS, in this example we will use the Ubuntu 20.04.5.

#### Prequisites

| Item | requirement| additional notes |
|---|---|---|
|hostnames |  prepare hostnames for each of the nodes | follow a naming standard |
|IP address |  Assign and plan the IP address to be used | The IP range might be different in your environment. The IP used here should match most home lab setups|
|Ubuntu ISO image  |  Download the latest Ubuntu image. The non GUI version is installed . Save to D:\Downloads\ to match the PS script path |[Ubuntu Official](https://ubuntu.com/download/server)
|Terminal program|Putty or any other program|[Putty official site](https://www.putty.org/)|


#### Server , Hostname and IP address assigned
| Server | hostname|  IP address| subnet mask | Gateway |
|---|---|---|---|---|
|management | k3s-mgmt-lab-01 | 192.168.0.230| /24 | 192.168.0.1|
|k3s server 01|k3s-single-lab-01|192.168.0.231 |/24 |192.168.0.1|
|k3s server 02|k3s-single-lab-02|192.168.0.232 |/24 |192.168.0.1|

Local login credentials to create
| login id | Password|  notes |
|---|---|---|
|k3s | your prefered password ||

Total Ubuntu installation time about 16 minutes per host.

Please refer to the video for a step by step installation.

Repeat the same for the nodes `k3s-single-lab-01` and `k3s-single-lab-02`

Once each of the server installation is completed we can test connectivity via a terminal program.
Here we explain with Putty.


#### Connectivity check.

Start Putty.
1. update the IP address of the server.
2. connection type is SSH
3. Name the session
4. click save.
5. Click on Open to connect to the server

![[Pasted image 20230108215546.png]]

The first time you connect a "Putty Security Alert" will appear, click on Accept.

![[Pasted image 20230108221226.png]]


#### Access node using servername.
With the current setup, we can reach each of the ubuntu servers using the IP address.
This is because I do not have a DNS setup I can use to register the ubuntu hostnames with the assigned IP.

###### Workaround. 
In a production environment we will use the hostnames to reach each of the servers.
As a workaround, we can update the hosts file on the management server. The hosts file will map the IP to the hostname.
From the k3s-mgmt-lab-01 console
`sudo vi /etc/hosts`
`sudo - command elevates the terminal to elevated privileges`
`vi - a text editor `

Once the hosts file is open. 
1. move the cursor to the end of k3s-mgmt-lab-01
2. press `I`  to enter edit mode
3. type the following

`192.168.0.231 k3s-single-lab-01`
`192.168.0.232 k3s-single-lab-02`

4. press `esc` button
5. type `:x` and enter to save and exit.
Here is a screenshot for reference.
![[Pasted image 20230108214113.png]]

We can now ping the hostname of the remote servers from the management terminal
![[Pasted image 20230108214608.png]]

We have completed installation of Ubuntu.


Rerecord Video installation
