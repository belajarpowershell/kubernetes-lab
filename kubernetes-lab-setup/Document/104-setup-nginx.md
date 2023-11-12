# `alpine1` setup and configuration.

## Configure DHCP

```
#install nginx 
apt update
apt upgrade
apt install nginx

#check nginx service status
systemctl status nginx

#Nginx configuration
# no change required in this lab setup
vi /etc/nginx/nginx.conf

```




Configure a new site to list the files over http.
```
# reference link
# https://stackoverflow.com/questions/18954827/how-to-serve-images-with-nginx

# nginx installs with a default site 
# this site will intefere with the new site we are setting up.

# remove default site
rm /etc/nginx/sites-enabled/default

# create a file for the site .
touch /etc/nginx/sites-available/installfileserver

vi /etc/nginx/sites-available/installfileserver

# paste the following code.
server {
    server_name localhost;
    root /srv/installfileserver;
    #index index.html;
    location / {  # new url path # this is the URL path on browser
	alias /srv/installfileserver/; # directory to list
    #in this case http://ip/ will list files in "/srv/fai/"
	autoindex on;
    }

}

ln -s /etc/nginx/sites-available/serve-iso /etc/nginx/sites-enabled/
```

Check nginx config after every change for errors
```
#check syntax 
nginx -t
#reload nginx
systemctl reload nginx 

``` 


Validate 


```
# create a file to be listed
touch /srv/installfileserver/test.txt


#In a browser open the following URL
https://192.168.100.1

The list of files hosted in `/srv/installfileserver/` will be listed.

```
