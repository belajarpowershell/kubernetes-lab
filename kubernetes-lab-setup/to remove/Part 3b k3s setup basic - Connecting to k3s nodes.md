
Connecting to the k3s nodes is a bit more challenging.


#### Prequisites

| Item | requirement| additional notes |
|root access| must have root access to complete the configuration| when setting up Ubuntu we created the login "k3s" and a password. |

#### Step 1 
Install kubectl on the management server
Details available here [Kubectl official ](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

The following command downloads and installs  the latest kubectl.

	a.   `curl -LO "https://dl.k8s.io/release/$(curl -L -s
				https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"`
	b.  `sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl`

#### Step 2
copy remote file `/etc/rancher/k3s/k3s.yaml` to management server

Commands run on the management server 
copy file on remote server to a read permission location i.e. remote profile of user copying file
```

mkdir ~/.kube/remote -p	ssh -t k3s@192.168.0.206 "sudo cat /etc/rancher/k3s/k3s.yaml > /home/k3s/.kube/config206"

```

Use scp to copy file from remote server.

```
`scp k3s@192.168.0.206:/etc/rancher/k3s/k3s.yaml ~/.kube/remote/config-206`

```

### Step 3

replace 127.0.0.1 with IP of remote cluster on the config file copied.

```
sed -ie s/127.0.0.1/ip-node/g config_file_location
sed -ie s/127.0.0.1/192.168.0.206/g ~/.kube/remote/config-206
```


