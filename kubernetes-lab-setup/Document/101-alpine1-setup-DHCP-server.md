# `alpine1` setup and configuration.


## Install and Configure DHCP

For the initial setup we will have the basic DHCP configuration.

```
#install dhcpd
apk add dhcp
```

Update the file /etc/dhcp/dhcpd.conf with the content below.

Use VI editor to edit ( or any other you are familiar with)
```
# using console you cannot copy paste, must type in manually
# create config file 
touch /etc/dhcp/dhcpd.conf
# edit config file
vi /etc/dhcp/dhcpd.conf

subnet 192.168.100.0 netmask 255.255.255.0 {
  range 192.168.100.100 192.168.100.200;
  option domain-name-servers 192.168.100.1;
  option routers 192.168.100.1;
}
[esc] :x[enter] to save and exit
```
> routers : The routers IP usually is the WIFI or WAN router IP. In this lab setup we want emulate an office network setup.
> In the subsequent steps we will review how to setup alpine1 as a Router.

> domain-name-servers : in this setup we want to resolve some internal hostnames  that cannot be resolved by public DNS servers.
> We want to have alpine1 to function as DNS server and also forward DNS request not resolved locally.
> The steps to configure alpine1 as DNS server is reviewed later.

## Restart the DHCP deamon
To refresh the updated configuration restart the DHCP services.
Any errors in configuration will appear at this point.
```
# start the dhcpd service.
rc-service dhcpd start
```
DHCP logs
```
cat /var/lib/dhcp/dhcpd.leases

cat /etc/dhcp/dhcpd.conf
```

## DHCP Setup is complete  for alpine1 server .

## Steps to ssh.

Since the DHCP is now setup the Hyper-V host can now get and IP assigned.
You can do this by running from Windows Terminal ( run as Administrator).

```
ipconfig /renew 
```
Run this command on Windows Terminal to check if an IP has been assigned
```

get-netipaddress -InterfaceIndex (Get-NetAdapter | Where-Object { $_.Name -like "*192.168.100.0*" }).InterfaceIndex
```
![alt text](./screenshots/Alpine1-screenshots/WindowsTerminal_checkIP.png)

## How to identify the IP address on a linux machine?
At the prompt type.
```
  ip a 
```
Here is an example 
![alt text](./screenshots/Alpine1-screenshots/alpine-get-ip-address.png)

## How to SSH to a Linux Machine?

Use a terminal client.Putty is a good terminal to use.
In Windows 11 as I have Terminal client installed I will be using this lab.
But any terminal program can be used.

 
Back to ssh from Windows terminal
I will peform further configuration from the Windows Terminal as I will be able to copy and paste commands.

```
ssh -l root 192.168.100.1
```
![alt text](./screenshots/Alpine1-screenshots/WindowsTerminal_ssh-alpine1.png)


## DHCP is installed and SSH to `alpine1` server established.

## Next step

We will proceed with the router installation. 

The validation for DHCP and Internet on the private network will be tested at a later stage.

Please continue with 
# [101-faiserver-server-setup.md](./101-faiserver-server-setup.md)
