# `alpine1` setup and configuration.

## Configure DNS server

```
# Install bind ( DNS server) and tools dig and nslookup on alpine1.
apk add bind bind-tools


# start bind service. ( the service name is 'named') 

rc-service named restart 

# check if the tools are installed.
dig -v
nslookup -v

```

Configure bind with a zone and resolve internet names from the configured forwarders.
```
vi /etc/bind/named.conf
# replace or edit the file to reflect the following.

options {
     listen-on port 53 { 127.0.0.1; 192.168.100.1; };
     forwarders { 8.8.8.8; 8.8.4.4; };
     directory "/var/bind";
     dump-file "/var/bind/data/cache_dump.db";
     statistics-file "/var/bind/data/named_stats.txt";
     memstatistics-file "/var/bind/data/named_mem_stats.txt";
     allow-query { localhost; 192.168.100.0/24; };
     recursion yes;
};
zone "k8s.lab" IN {
        type master;
        file "/etc/bind/master/k8s.lab";
};

```

Create the zone file. In this lab the domain used is k8s.lab

```
vi /etc/bind/master/k8s.lab
# paste following 
$TTL 38400
@ IN SOA ns.k8s.lab admin.k8s.lab. (
2       ;Serial
600     ;Refresh
300     ;Retry
60480   ;Expire
600 )   ;Negative Cache TTL

@       IN      NS      ns1.k8s.lab.
ns1     IN      A       192.168.100.1
alpine1         IN      A       192.168.100.1
k8s-ha-cluster  IN      A       192.168.100.201
loadbalancer    IN      A       192.168.100.201
master1         IN      A       192.168.100.202
master2         IN      A       192.168.100.203
master3         IN      A       192.168.100.204
worker1         IN      A       192.168.100.205
worker2         IN      A       192.168.100.206
worker3         IN      A       192.168.100.207
```

Validate the bind configuration
```
named-checkconf /etc/named.conf

# (re)start bind service. ( the service name is 'named') 

rc-service named restart 

# ensure no errors are returned
```


Validate DNS.

```
To validate you need to run nslookup on a remote server. 
As there are no servers setup, this can be validated when the VM's are created.

```
