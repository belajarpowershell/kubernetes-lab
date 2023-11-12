# `alpine1` setup and configuration.

## Configure PXE configurations

[syslinux files with PXE boot menu enabled](https://www.rodsbooks.com/efi-bootloaders/syslinux-6.0.3+dfsg-14.t)

Copy following files from 

``` 
syslinux-6.03\efi64\com32\menu\menu.c32
syslinux-6.03\efi64\com32\libutil\libutil.c32
```
sss

for vesamenu
```
iso\syslinux-6.03\efi64\efi\syslinux.efi
iso\syslinux-6.03\efi64\com32\elflink\ldlinux\ldlinux.e64
syslinux-6.03\bios\com32\elflink\ldlinux\ldlinux.c32
syslinux-6.03\efi64\com32\menu\vesamenu.c32
syslinux-6.03\efi64\com32\lib\libcom32.c32


```


[syslinux 6.03 zip](https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/6.xx/)



## Update pxelinux.cfg/default 

```
path splash/
path c32/
DEFAULT ubuntu
TIMEOUT 50
UI vesamenu.c32
MENU RESOLUTION 1024 768
MENU BACKGROUND splash/pine-green-splash.png
MENU TITLE PXE Boot Menu

LABEL fai-server
    MENU LABEL fai-server
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
Scratch
LABEL ubuntu
    MENU LABEL ubuntu
    KERNEL http://192.168.33.250/tftp/fai/ubuntu/casper/vmlinuz
    INITRD http://192.168.33.250/tftp/fai/ubuntu/casper/initrd
    # pass user-data in  append
    #working	
	append url=http://192.168.33.250/ubuntu-iso-mnt/ubuntu-20.04.6-live-server-amd64.iso autoinstall ds=nocloud-net;s=http://192.168.33.250/fai/autoinstalldata/ ip=dhcp fsck.mode=skip ---
	
	#scratch
    APPEND root=/dev/ram0 ramdisk_size=1500000 ip=dhcp url=http://10.10.2.1/ubuntu-20.10-live-server-amd64.iso autoinstall ds=nocloud-net;s=http://10.10.2.1/ubuntu-server-20.10/
	APPEND root=/dev/ram0 ramdisk_size=1500000 url=http://192.168.33.250/fai/ubuntu/ubuntu-20.04.6-live-server-amd64.iso autoinstall ds=nocloud-net;s=http://192.168.33.250/fai/autoinstalldata/
	
	append url=http://192.168.33.250/ubuntu-iso-mnt/ubuntu-20.04.6-live-server-amd64.iso autoinstall ds=nocloud-net;s=http://192.168.33.250/ks/ cloud-config-url=/dev/null ip=dhcp fsck.mode=skip ---
 
 
```