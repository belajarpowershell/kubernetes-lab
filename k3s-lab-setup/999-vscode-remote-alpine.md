https://www.reddit.com/r/vscode/comments/smw8tn/working_with_remote_ssh_in_alpine/

https://johnsiu.com/blog/alpine-vscode/

vi /etc/ssh/sshd_config

```
apk add wget tar gzip gcompat libstdc++6 libuser bash python2
```

```
touch /etc/login.defs
mkdir /etc/default
touch /etc/default/useradd
lchsh root # apk login used
```

When asked what shell to use enter `/bin/bash`



restart alpine server



