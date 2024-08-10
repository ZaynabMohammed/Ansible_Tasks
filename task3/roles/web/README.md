web
=========
Requirements
------------
1. installing a package (get the package name from vars)    
   && (will notify both copying handlers)  
2. Copying a file from controller to hosts using template (get the template name & template message from vars)   
   && (the actual template file will be stored in ./roles/web/templates)  
   && (will notify the restart handler)   
3. Copying a list of files from controller to hosts using loop (get the list of file names from vars)  
   && (the actual files will be stored in ./roles/web/files)  
   && (will also notify the restart handler)  
4. Restart the service of the installed package (will be executed using Handlerschaining)  

Role Tasks
--------------
1. `Install latest nginx` task, that will notify two handlers:
   a. `Copy_files_task_name` handler
   b. `template_task_name` handler

Role Handlers
--------------
1. `Copy_files_task_name` handler, which notified by `Install latest nginx` task
2. `template_task_name` handler, which notified by `Install latest nginx` task
3. `restart_Nginx` hadler, which notified by `Copy_files_task_name` && `template_task_name`
   
Role Variables
--------------
1. Copy_files_task_name
2. template_task_name
3. list_of_files:
  - index.html
  - hello.txt
4. msg: "Hello_Ansible" --->template will use this massage

Role Files
--------------
Contain files that will be used by `Copy_files_task_name` handler.
   - index.html
   - hello.txt
      
Role Templates
--------------
- Contain `Jinja2` file that will be used by `template_task_name` handler.  
--> will generate file with `[host_name, ipaddress]` which will be taken from inventory file and `[msg]` which will be taken from variables.
```bash
hostname, ipaddress, msg
{% for host in groups['targets_based_on_Docker'] %}
{{ host }}, {{ hostvars[host]['ansible_host'] }}, {{ msg }}
{% endfor %}
```
