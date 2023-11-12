# `alpine1` setup and configuration.

## Configure DHCP
For the initial setup we will have the basic DHCP configuration.

Update the file /etc/dhcp/dhcpd.conf with the content below.

Method 1 using VI editor
```
vi /etc/dhcp/dhcpd.conf

subnet 192.168.100.0 netmask 255.255.255.0 {
  range 192.168.100.100 192.168.100.200;
  option domain-name-servers 8.8.8.8;
  option routers 192.168.100.1;
     host faisvr {
        hardware ethernet 00:15:5d:00:8a:3d; # change to your MAC address. 
        fixed-address 192.168.100.250;
    }
}
[esc] :x[enter] to save and exit
```
Method 2 echo to filename.
```
Paste the following in the alpine1 ssh terminal.

echo "subnet 192.168.100.0 netmask 255.255.255.0 {
  range 192.168.100.100 192.168.100.200;
  option domain-name-servers 8.8.8.8;
  option routers 192.168.100.1;
}" |  tee -a /etc/dhcp/dhcpd.conf

```
#### Restart the DHCP deamon
To refresh the updated configuration restart the DHCP services.
Any errors in configuration will appear at this point.
```
rc-service dhcpd start
rc-service networking restart
```
DHCP logs
```
cat /var/lib/dhcp/dhcpd.leases

cat /etc/dhcp/dhcpd.conf
```

### Setup is complete  for alpine1 server .


## Next step

We will proceed with the fai-server installation 

The validation for DHCP and Internet on the private network will be tested at a later stage.

Please continue with 
# [101-faiserver-server-setup.md](./101-faiserver-server-setup.md)
