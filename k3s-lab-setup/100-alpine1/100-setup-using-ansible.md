**Step 1**. Update official Alpine packages.

```
sudo apk update
```

**Step 2**. Install Ansible.

```
sudo apk add ansible
```

**Step 3**. Verify installation.

```
ansible --version
```



```
execute the playbook run from `/srv/ansible`
ansible-playbook 00-apt-update.yml  --user ubuntu --ask-become-pass  -i hosts.ini
```

