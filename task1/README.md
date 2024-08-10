# Task 1: Use ansible [modules, handlers] to:
  1. Update cache.
  2. Install latest nginx
  3. Copy index.html from controller to host 1 & host 2
  4. Restart nginxservice

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

PLAY [nginx_playbook] *******************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************
ok: [target1]
ok: [target2]

TASK [Update apt cache] *****************************************************************************************************************************************
ok: [target2]
ok: [target1]

TASK [Install latest nginx] *************************************************************************************************************************************
changed: [target2]
changed: [target1]

TASK [Copy index.html] ******************************************************************************************************************************************
changed: [target2]
changed: [target1]

RUNNING HANDLER [restart_Nginx] *********************************************************************************************************************************
changed: [target2]
changed: [target1]

PLAY RECAP ******************************************************************************************************************************************************
target1                    : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
target2                    : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
### 4) Go inside both container to check new index.html
```bash
$ docker exec -ti host1 bash
cat /usr/share/nginx/html/index.html
<h1> "Hello World" </h1>
exit
$ docker exec -ti host2 bash
cat /usr/share/nginx/html/index.html
<h1> "Hello World" </h1>
exit
```
