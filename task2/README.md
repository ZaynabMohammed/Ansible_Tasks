# Task 2: [Vars, Loops, Register, When]:
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
#### A) Vars with Loops
```bash
$ ansible-playbook playbook.yml
PLAY [nginx_playbook] *******************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************
ok: [target1]
ok: [target2]

TASK [Update apt cache] *****************************************************************************************************************************************
changed: [target1]
changed: [target2]

TASK [Install packages based on dictionary values] **************************************************************************************************************
changed: [target2] => (item={'name': 'nginx', 'state': 'absent'})
changed: [target1] => (item={'name': 'nginx', 'state': 'absent'})
changed: [target1] => (item={'name': 'nodejs', 'state': 'latest'})
changed: [target2] => (item={'name': 'nodejs', 'state': 'latest'})
changed: [target1] => (item={'name': 'postgresql', 'state': 'present'})
changed: [target2] => (item={'name': 'postgresql', 'state': 'present'})

PLAY RECAP ******************************************************************************************************************************************************
target1                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
target2                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
#### B) Register with when
```bash
$ ansible-playbook playbook_when_Reg.yml
PLAY [nginx_playbook] *******************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************
ok: [target1]
ok: [target2]

TASK [Update apt cache] *****************************************************************************************************************************************
ok: [target1]
ok: [target2]

TASK [Install nginx package] ************************************************************************************************************************************
ok: [target1]
ok: [target2]

TASK [view register] ********************************************************************************************************************************************
ok: [target1] => {
    "result.changed": false
}
ok: [target2] => {
    "result.changed": false
}

TASK [restart nginx if installtion task changed] ****************************************************************************************************************
skipping: [target1]
skipping: [target2]

PLAY RECAP ******************************************************************************************************************************************************
target1                    : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
target2                    : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```
