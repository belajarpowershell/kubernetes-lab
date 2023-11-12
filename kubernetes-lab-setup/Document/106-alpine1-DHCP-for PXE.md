vi /etc/dhcp/dhcpd.conf

subnet 192.168.100.0 netmask 255.255.255.0 {
   range 192.168.100.50 192.168.100.100;
   option routers 192.168.100.1;
#   option domain-name "fai"; # removing references that use Name Server
   option domain-name-servers 8.8.8.8;
   option time-servers 192.168.100.1;
   option ntp-servers 192.168.100.1;
#   server-name "faiserver";  # removing references that use Name Server
   next-server 192.168.100.1;
   if substring(option vendor-class-identifier, 0, 20) = "PXEClient:Arch:00000" {
         filename "bios/pxelinux.0";
   }
   if substring(option vendor-class-identifier, 0, 20) = "PXEClient:Arch:00007" {
         filename "efi64/syslinux.efi";
   }
   #assign IP based on MAC address
   host faisvr {
        hardware ethernet 00:15:5d:00:8a:3d; # change to your MAC address. 
        fixed-address 192.168.100.250;
    }
}



path bios/,efi64,splash/
DEFAULT ubuntu
TIMEOUT 50
UI vesamenu.c32
MENU RESOLUTION 1024 768
MENU BACKGROUND splash/pine-green-splash.png
MENU TITLE PXE Boot Menu


LABEL ubuntu
    MENU LABEL ubuntu
    KERNEL http://192.168.100.1/tftp/ubuntu/casper/vmlinuz
    INITRD http://192.168.100.1/tftp/ubuntu/casper/initrd


    append url=http://192.168.100.1/ubuntu-iso-mnt/ubuntu-20.04.6-live-server-amd64.iso autoinstall ds=nocloud-net;s=http://192.168.100.1/autoinstalldata/ ip=dhcp fsck.mode=skip ---
