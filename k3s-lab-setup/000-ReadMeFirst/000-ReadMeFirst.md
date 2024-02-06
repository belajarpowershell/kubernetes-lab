 Folder Structure

- /kubernetes-lab
  
  - k3s-lab-setup
  
    - The server sequence of setup
  - scripts
  - srv/
  
    - tftp/
      - bios
        - 
      - efi64
        - 
    - autoinstall/
      - add-passphrase.sh
      - copy-ssh-key.sh
      - hosts.ini
    - ansible/
      - playbook
        - .kube/
        - j2/
  

```

## This script is to download the folder /srv from the Repository https://github.com/belajarpowershell/kubernetes-lab

# initialize a new folder
git init kubernetes-lab
# change folder
cd kubernetes-lab
# add git repository to folder. 
git remote add origin https://github.com/belajarpowershell/kubernetes-lab.git
# enable sparsecheckout
git config core.sparsecheckout true
# specify folder to pull
echo "srv/*" >> .git/info/sparse-checkout

# pull files locally.
git pull --depth=1 origin main

#create folder /srv if not already existing.
[ -d "/srv" ] || mkdir -p /srv && echo "Created /srv directory" || echo "/srv directory already exists"


# move files to the /srv folder.
mv srv/* /srv
echo " files moved to /srv " 
echo " script completed"

# create a file download-srv.sh with above contents on `alpine1`
# run following command to make this executable
# chmod +x download-srv.sh
# run the script
# ./download-srv.sh 

```

