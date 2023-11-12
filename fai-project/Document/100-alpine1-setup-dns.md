#dns on alpine

 Install bind and  dig and nslookup on Alpine.
```
apk update
apk add dhcp
rc-update add dhcpd ##startup at boot
rc-service named restart 
apk add bind bind-tools
apk del --purge bind
dig -v
nslookup -v

```
##bind config file
```
vi /etc/bind/named.conf

options {
  directory "/var/bind";
  pid-file "/var/run/named/named.pid";
  recursion yes;
  forwarders { 8.8.8.8; };
  allow-transfer { any; };
  allow-query { any; };
  listen-on { any; };
  listen-on-v6 { none; };
};

zone "k8s.lab" IN {
  type master;
  file "/etc/bind/zone/k8s.lab";
};
```



```
vi /etc/bind/master/k8s.lab
$TTL 38400
@ IN SOA ns.k8s.lab admin.k8s.lab. (
2       ;Serial
600     ;Refresh
300     ;Retry
60480   ;Expire
600 )   ;Negative Cache TTL

@       IN      NS      ns1.k8s.lab.
ns1     IN      A       192.168.33.1
alpine1         IN      A       192.168.33.1
k8s-ha-cluster  IN      A       192.168.33.201
alpinelb        IN      A       192.168.33.201
master1         IN      A       192.168.33.202
master2         IN      A       192.168.33.203
master3         IN      A       192.168.33.204
worker1         IN      A       192.168.33.205
worker2         IN      A       192.168.33.206
worker3         IN      A       192.168.33.207
faisvr          IN      A       192.168.33.250
```
