## FAI server application setup.

## pre requisites
# install wget

Elevate rights 
```
su -l
```
Update install repository
```
apt-get update
apt install wget
```

# Next is the FAI server application setup.
###############
Most reference are from this URL , there are some differences as this setup is on Hyper-V the reference is based on qemu. I have listed down the steps to setup on Hyper-V Virtual Machines.

https://fai-project.org/fai-guide/
section :Setup your faiserver


```
wget -O fai-project.gpg https://fai-project.org/download/2BF8D9FE074BCDE4.gpg
cp fai-project.gpg /etc/apt/trusted.gpg.d/
echo "deb http://fai-project.org/download buster koeln" > /etc/apt/sources.list.d/fai.list
apt-get update
apt install fai-quickstart

## you might see errors on dhcp , this can be ignored as in this setup DHCP is hosted on alpine1
```

Create the nfsroot
```
sed -i -e 's/^#deb/deb/' /etc/fai/apt/sources.list
sed -i -e 's/#LOGUSER/LOGUSER/' /etc/fai/fai.conf
```

The faiserver setup begins here.
```
fai-setup -v
```

## Configuration space
The configuration space is created. Not sure what this is at this time.
But looks like files the new Client Server will use at installation.

```
fai-mk-configspace # this is already done by `fai-setup` so no need to repeat.
creates following folder with contents
/srv/fai/config/
basefiles  class  debconf  disk_config  files  hooks  package_config  scripts  tests

```
## Check nfs configuration

the fai-setup would have created the relevant nfs configuration. But as I have deviated from the standard setup the nfs configuration needs to be validated.

Ensure the IP address configured shows the correct IP in this case it should be
`192.168.33.250`.

```
root@faiserver:~# vi  /etc/exports
# /etc/exports: the access control list for filesystems which may be exported
#               to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
#
/srv/fai/config 192.168.33.250/24(async,ro,no_subtree_check)
/srv/fai/nfsroot 192.168.33.250/24(async,ro,no_subtree_check,no_root_squash)

[esc] :x[enter] to save and exit
```
Reload the nfs configuration
```
exportfs -a
```
Test mount the nfs on alpine1
```
# install nfs-utils
apk add nfs-utils

mkdir /nfstest -p
mount -t nfs 192.168.33.250:/srv/fai/nfsroot /nfstest

# to check the exising mounts in place.
mount 
# to unmount the mounted nfs
umount /nfstest 

```

## We have now completed the faiserver setup. 

Next we have to configure the DHCP the will provide relevant information used by the network boot to install OS on a remote server.


103-DHCP-setup.md