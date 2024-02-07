# Kubernetes Lab Setup

In this step we will download the 

#####  This script is to download the folder /srv from the Repository https://github.com/belajarpowershell/kubernetes-lab

```
# create a file download-srv.sh with below contents on `alpine1`
# run following command to make this executable
# chmod +x download-srv.sh
# run the script
# ./download-srv.sh 

# This script will pull the specific folder/srv from the git repository and move the contents to the /srv on alpine1.

# install git 
apk add git

# clone the repository
git clone https://github.com/belajarpowershell/kubernetes-lab.git

# change folder
cd kubernetes-lab

# move the `srv` from git folder "kubernetes-lab/" to "/srv" 
# change the script to executable
chmod +x move-srv-files2root.sh

#run the script 
./move-srv-files2root.sh

# files `kubernetes-lab/srv` folder is now moved to /srv
# this is important as the files required for the setup must be located at `/srv/`

```

## Folder Structure

- /kubernetes-lab
    - k3s-lab-setup
      - The server sequence of setup
  - scripts
  - srv/
      - tftp/
      - bios
      - efi64
    - autoinstall/
      - add-passphrase.sh
      - copy-ssh-key.sh
      - hosts.ini
    - ansible/
      - playbook
        - .kube/
        - j2/


```
