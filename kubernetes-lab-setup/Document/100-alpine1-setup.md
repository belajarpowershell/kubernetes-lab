# `alpine1` setup and configuration.

## Initial Alpine OS setup

#### Key information
```
Alpine Default login
login : root
password : blank
```
## Hyper-V configuration for reference
![alt text](./screenshots/Alpine1-screenshots/Hyper-V-alpine1-config-overview.png)


## Alpine install ISO first boot
![alt text](./screenshots/Alpine1-screenshots/Alpine-boot-from-alpine-install-iso.png)


#### Disable IPv6 on Alpine 
In my setup IPv6 was not workinging if you have issues with IPv6, do disable before proceeding.

 Edit the /etc/sysctl.conf

```
vi /etc/sysctl.conf
# Manualy type in the followingf
# press [i] to be in insert /edit mode

net.ipv6.conf.all.disable_ipv6 = 1
# to save and exit following key press
# [esc] :x! [enter]

# reload the configuration
sysctl -p
```

## Install Alpine 
After logging on at the prompt type 
``` 
setup-alpine
``` 
You will be asked a series of questions . I have listed my selection.
```
Keyboard Layout : [us]
Keyboard variant : [us]
Hostname : [alpine1]
Network :
eth0: [dhcp]  # Internet connection
eth1: [192.168.100.1/24]
gateway: [none]
password : [abc123]
DNS Servers :
Timezone :[Singpore]
Proxy :[none]
ntp: default [chrony]  #if it takes long to complete , make sure ipv6 is disabled
Mirror :[f] # Detect and add fastest mirror
setup user : [no]
Which ssh server? [openssh]
allow root ssh login: [yes]
Allow ssh login : [yes]
Which disks would you like to use : [sda]
Disk Mode How would you like to use it ? [sys]
Erase the above disks and continue? [y]
```

## Installation begins.
Once the installtion is completed you will see the notice to reboot.
Before rebooting, change the boot sequence in Hyper-V for alpine1 to be Hard Drive first.

This will ensure the reboot will be to the Hard Disk.
![alt text](./screenshots/Alpine1-screenshots/Hyper-V-alpine2-boot-sequence-change-after-alpine-setup-completed.png)
On the apline1 Hyper-V console.
the prompt will display press [enter]
```
installation complete type reboot [enter]
```

## Setup completed 


These are the credentials for newly installed alpine1 . 
```
login: root
pass: abc123
```
This screen will appear , take note of the login prompt **'alpine1'**. Indicating the installation is completed.

![alt text](./screenshots/Alpine1-screenshots/vmconnect_odjAAmfYDN.png)
## Connect via ssh
If you don't already know the Hyper-V console is not able to perform copy and paste operations. Via a terminal connection copy and paste functions make it easier to paste commands , especially the long ones.

## Steps to ssh.
- Identify the IP address  type `ip a` at the prompt.
![alt text](./screenshots/Alpine1-screenshots/alpine-get-ip-address.png)

- Use a terminal client. Putty is a good terminal to use. Windows 11 as a Terminal client installed I will be trying that in this example.But any terminal program can be used.

eth1 : 192.168.100.1 # This IP is accesible from your Hyper-V host.
 you may have to setup a static IP on the Network interface .
 in my case I used 192.168.100.10/24
 On Windows go to :
 
 Control Panel\Network and Internet\Network Connections
 
 Look for Connection name : vEthernet (Private 192.168.100.0 24)
 assign the static IP  192.168.100.10, Subnet Mask 255.255.255.0 

 
Back to ssh from Windows terminal
```
ssh -l root 192.168.100.1
```
![alt text](./screenshots/Alpine1-screenshots/WindowsTerminal_ssh-alpine1.png)


### Setup and ssh to server validated


## Next step

We will proceed to setup alpine1 as a Router 

Please continue with 
# [101-faiserver-server-setup.md](./101-faiserver-server-setup.md)
