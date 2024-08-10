# Task 3: [Roles && Templates]:
## Steps
### 1) Use Docker to power up multiple Docker containers to act as target servers for Ansible.
```bash
$ docker build .
$ docker run -d --name host1 ce029823eff8
$ docker run -d --name host2 ce029823eff8
$ docker ps
CONTAINER ID   IMAGE          COMMAND               CREATED          STATUS          PORTS     NAMES
04658861b9f4   ce029823eff8   "/usr/sbin/sshd -D"   6 seconds ago    Up 6 seconds    22/tcp    host2
5d71819b9306   ce029823eff8   "/usr/sbin/sshd -D"   14 minutes ago   Up 14 minutes   22/tcp    host1
```
### 2) Run docker inspect to get IPs of both containers to build inventory file
```bash
target1 ansible_host=172.17.0.2 ansible_ssh_pass=Passw0rd
target2 ansible_host=172.17.0.3 ansible_ssh_pass=Passw0rd
```
### 3) Run ansible playbook
```bash
$ ansible-playbook playbook.yml
PLAY [Install nginx] **************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [target1]
ok: [target2]

TASK [web : Install latest nginx] *************************************************************************************
changed: [target2]
changed: [target1]

RUNNING HANDLER [web : Copy_files] *************************************************************************************
changed: [target2] => (item=index.html)
changed: [target1] => (item=index.html)
changed: [target1] => (item=hello.txt)
changed: [target2] => (item=hello.txt)

RUNNING HANDLER [web : Copy_with_template] ******************************************************************************
changed: [target1]
changed: [target2]

RUNNING HANDLER [web : restart_Nginx] ************************************************************************************
changed: [target2]
changed: [target1]

PLAY RECAP ****************************************************************************************************************
target1                    : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
target2                    : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
### 4) Go inside both container to check that files are copied.
- The below check is for host1, and host2 will be the same thing.
```bash
$ docker exec -ti host1 bash
:/# cd /root
:~# ls
hosts_info.txt
:~# cat hosts_info.txt
hostname, ipaddress, msg
target1, 172.17.0.2, Hello_Ansible
target2, 172.17.0.3, Hello_Ansible
:~# cd /usr/share/nginx/html/
:/usr/share/nginx/html# ls
hello.txt  index.html
:/usr/share/nginx/html# cat index.html
<h1> "Hello World" </h1>
:/usr/share/nginx/html# cat hello.txt
NoThing!!
```
