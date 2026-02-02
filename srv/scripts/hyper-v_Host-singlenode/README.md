# Powershell script to create VMs to create single node k3s instances

Run from Windows server hosting HyperV


## Update VM inventory

```
001-Kubernetes-Create-HyperV-VM.csv
```

## Run Powershell script to create VM

```
001-Kubernetes-Create-HyperV-VM.ps1
```

## Start and stop VM to generate MAC address

```
get-hyperv-start-stopVM.ps1
```

## Update DNS server with IP -hostname
In this example will be the Alpine management server hosting the DNS

```
ip-address.md
```


## Generate the Automation files to install ubuntu

```
get-hyperv-start-stopVM.ps1
```

## Copy automation files to Ansible server

refer to
[Ubuntu Installation](https://belajarpowershell.github.io/kubernetes-lab-setup/100-alpine1/113-Install-Ubuntu/)


