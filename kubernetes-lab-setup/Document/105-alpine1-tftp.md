# `alpine1` setup and configuration.

## Install and Configure tftpd

```
#install nginx 
apk update
apk add tftp-hpa

# set nginx to start at boot
rc-update add in.tftpd

# Update in.tftpd configuration
vi /etc/conf.d/in.tftpd
  #change or update row to reflect correct path
  INTFTPD_PATH="/srv/tftp/"

#check in.tftpd  service status
rc-service in.tftpd status

#Start service now
rc-service in.tftpd start
```

The path `/srv/tftp/` is important to note as the subsequent configuration will use this folder as root.
