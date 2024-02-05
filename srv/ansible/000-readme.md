ansible-playbook k3s-get-token.yml  --user ubuntu --ask-become-pass  -i inventory/hosts.ini
00-apt-update.yml

> - Performs apt-update on all Ubuntu servers
> - Installs kubectl on `alpine1`



01-k3s-loadbalancer-setup.yml

> - Installs Docker  and Nginx on the Loadbalancer

j2\nginx.conf.j2

> - When the load balancer is setup with `nginx` the required configuration for the loadbalancer is generated from the Jinja2 (j2) script.

02-k3s-HA-setup.yml

> - Installs k3s server on master1,master2 and master3
> - Installs k3s agent on worker1,worker2,worker3.

02z-k3s-copy-kubeconfig.yml

> - Copies kubeconfig files from cluster to  `ansible1` in the folder `/root/.kube./clusters/` to remotely manage the k3s cluster
> - The kubeconfig file also updates the names to be specific to the cluster.
> - Updates the localhost entries to `Loadbalancer`  

03-k3s-single-node-setup.yml

> - Installs k3s as a single instance.

03z-k3s-copy-kubeconfig-single.yml

> - Copies kubeconfig files from the single node k3s to  `ansible1`  in the folder `/root/.kube./clusters/` to remotely manage the k3s cluster
> - The kubeconfig file also updates the names to be specific to the cluster.
> - Updates the localhost entries to `Loadbalancer`  



98-k3s-remove-all.yml

> - If there is a need to remove the k3s installations this playbook removes the k3s from  `master1,master2 ,master3,worker1,worker2,worker3,xsinglenode`

ansible-vars.yml

> - The ansible variables are stored in this file. 
> - In this example the file stores the various setup commands to install `k3s' for the different roles. 