

Define hosts

```
hosts.ini
```

To enable Ansible to connect using ssh Pass

```
copy-ssh-key-singlenode.sh
```

Update nodes
```
ansible-playbook 00-apt-update.yml  --user ubuntu --ask-become-pass  -i hosts.ini
```

Install k3s 

```
ansible-playbook k3s-complete-setup.yml  --user ubuntu --ask-become-pass  -i hosts.ini
```


Create KUBECONFIG
```

export KUBECONFIG=$(for YAML in $(find ${HOME}/.kube/clusters -name '*.yaml') ; do echo -n ":${YAML}"; done)

```
Following KUBECONFIG files created

```
ctx-k3s-master.yaml
ctx-k3s-01.yaml
ctx-k3s-02.yaml
ctx-k3s-03.yaml
```



Used part of `k3s-complete-setup.yml `

```
generate_kubeconfig.sh
k3s-complete-setup.yml 
```

Cleanup

```
ansible-playbook 98-k3s-remove-all.yml --user ubuntu --ask-become-pass  -i hosts.ini
```