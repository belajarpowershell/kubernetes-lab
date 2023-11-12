
create new image in basefiles folder

/srv/fai/config/basefiles$ ./mk-basefile -h



deploy Ubuntu instead of default OS
``````
default ldlinux.c32

label fai-generated
kernel vmlinuz-6.1.0-13-amd64
append initrd=initrd.img-6.1.0-13-amd64 ip=dhcp root=/srv/fai/nfsroot:vers=3 rootovl FAI_FLAGS=verbose,sshd,createvt FAI_CONFIG_SRC=nfs://192.168.33.250/srv/fai/config FAI_ACTION=install


label Ubuntu20.04
kernel vmlinuz-6.1.0-13-amd64
append initrd=initrd.img-6.1.0-13-amd64 ip=dhcp root=/srv/fai/nfsroot:vers=3 rootovl FAI_FLAGS=verbose,sshd,createvt FAI_CONFIG_SRC=nfs://192.168.33.250/srv/fai/config FAI_ACTION=install

``````
