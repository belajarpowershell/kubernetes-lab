# this script moves files from git folder "kubernetes-lab/" to "/srv" 

#create folder /srv if not already existing.
[ -d "/srv" ] || mkdir -p /srv && echo "Created /srv directory" || echo "/srv directory already exists"


# move files to the /srv folder.
mv srv/* /srv
echo " files moved to /srv " 
echo " script completed"