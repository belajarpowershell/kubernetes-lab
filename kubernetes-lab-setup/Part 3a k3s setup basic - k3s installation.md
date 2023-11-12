
For part 3 we will now install the k3s on the `k3s-single-lab-01` and `k3s-single-lab-02`

###### Install k3s

To install k3s is very straightforward

The standard installation is using the following command
`curl -sfL https://get.k3s.io | sh - `

In this example we will 
-  not install traefik 
-  set the file permissions for `/etc/rancher/k3s/k3s.yaml`
- 

`curl -sfLv https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik --write-kubeconfig-mode=644" sh - `

Total time to install 41 seconds per node.

