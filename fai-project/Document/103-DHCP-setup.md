## DHCP and default fai-generated

label fai-generated
kernel vmlinuz-6.1.0-13-amd64
append initrd=initrd.img-6.1.0-13-amd64 ip=dhcp root=/srv/fai/nfsroot:vers=3 rootovl FAI_FLAGS=verbose,sshd,createvt FAI_CONFIG_SRC=nfs://192.168.33.250/srv/fai/config FAI_ACTION=install
 setup for network Boot.

If you are reading this , you would have completed 

100-alpine1-setup.md > this sets up the Internet gateway and the DHCP server.

101-faiserver-server-setup.md > this sets up the faiserver that will host the files for network boot and OS installation.

102-faiserver-application-setup.md


## DHCP on alpine1 

The next phase is to configure the DHCP server alpine1 (192.168.33.1) with additional information for clients to use at boot up.

You can refer to an example that you can use as a reference
```
cat /usr/share/doc/fai-doc/examples/etc/dhcpd.conf
```

As I dont have a Name server setup, I will change all references faiserver with the IP "192.168.33.250"
update the following to /etc/dhcp/dhcpd.conf


```
vi /etc/dhcp/dhcpd.conf

subnet 192.168.33.0 netmask 255.255.255.0 {
   range 192.168.33.100 192.168.33.200;
   option routers 192.168.33.1;
#   option domain-name "fai"; # removing references that use Name Server
   option domain-name-servers 8.8.8.8;
   option time-servers 192.168.33.250;
   option ntp-servers 192.168.33.250;
#   server-name "faiserver";  # removing references that use Name Server
   next-server 192.168.33.250;
   if substring(option vendor-class-identifier, 0, 20) = "PXEClient:Arch:00000" {
         filename "fai/pxelinux.0";
   }
   if substring(option vendor-class-identifier, 0, 20) = "PXEClient:Arch:00007" {
         filename "fai/syslinux.efi";
   }
   #assign IP based on MAC address
   host faisvr {
        hardware ethernet 00:15:5d:00:8a:3d; # change to your MAC address. 
        fixed-address 192.168.33.250;
    }
}

[esc] :x [enter] to save and exit.
```
Once the update is done you must reload the configuration.

 ```
 rc-service networking restart
 ```
# DHCP logs
```
cat /var/lib/dhcp/dhcpd.leases 

grep dhcpd /var/log/messages | tail -100
systemctl list-units --type=service --state=running
```

If there are any errors you will need to recheck the configurations for typo etc.

At this point try the alpine2 server with network boot. 
You will now get IP address assigned at boot time. 


## PXELINUX configuration
Configuration done on faiserver.

We are not done yet. THe DHCP server is now assigning IP address when a client is booting up using the network.

The next step is to prepare the correct configuration for the client to load the correct files.

The commands are performed on the faiserver.

fai-chboot -IFv -u nfs://192.168.33.250/srv/fai/config default
THis command is for a specific server with the name demohost. In this example I am trying for a generic setup. Once I am familiar with the basics I will setup these specific hostnames.
For now we are interested in the output generated.

/srv/tftp/fai/pxelinux.cfg/default

```
default fai-generated

label fai-generated
kernel vmlinuz-6.1.0-13-amd64
append initrd=initrd.img-6.1.0-13-amd64 ip=dhcp root=/srv/fai/nfsroot:vers=3 rootovl FAI_FLAGS=verbose,sshd,createvt FAI_CONFIG_SRC=nfs://192.168.33.250/srv/fai/config FAI_ACTION=install


#working ISO downloaded and installer started and user-data found. 12 November 2023s
LABEL ubuntu
    MENU LABEL ubuntu
    KERNEL http://192.168.33.250/tftp/fai/ubuntu/casper/vmlinuz
    INITRD http://192.168.33.250/tftp/fai/ubuntu/casper/initrd
    append url=http://192.168.33.250/ubuntu-iso-mnt/ubuntu-20.04.6-live-server-amd64.iso cloud-config-url=/dev/null ip=dhcp fsck.mode=skip ---
	
	#working 
	append url=http://192.168.33.250/ubuntu-iso-mnt/ubuntu-20.04.6-live-server-amd64.iso autoinstall ds=nocloud-net;s=http://192.168.33.250/fai/autoinstalldata/ ip=dhcp fsck.mode=skip ---
```


```
