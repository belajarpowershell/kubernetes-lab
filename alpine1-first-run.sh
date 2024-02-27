# this script copies files from git folder "kubernetes-lab/" to "/srv" 

#create folder /srv if not already existing.
[ -d "/srv" ] || mkdir -p /srv && echo "Created /srv directory" || echo "/srv directory already exists"


# move files to the /srv folder.
cp srv/* /srv -r
echo " files copied to /srv " 


# enable the community repository to install ansible
# Define the file path
repo_file="/etc/apk/repositories"

# Check if the repository line is commented out
if grep -q '^#.*\/community$' "$repo_file"; then
    # Remove the comment from the line
    sed -i 's/^#\(.*\/community\)$/\1/' "$repo_file"
    echo "Community repository enabled."
else
    echo "Community repository already enabled or not found."
fi

echo " Community repository enabled"

# Setup ansible 

apk add ansible 

# setup kubeclt 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo " download Ubuntu ISO"
# download Ubuntu ISO
mkdir -p /srv/tftp/iso

[ ! -f /srv/tftp/iso/ubuntu-20.04.6-live-server-amd64.iso ] && wget -P /srv/tftp/iso https://releases.ubuntu.com/20.04.6/ubuntu-20.04.6-live-server-amd64.iso

echo " script completed"