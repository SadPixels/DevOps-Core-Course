# Lab 6: Ansible Application Deployment

## Scope

This document describes Lab 6 Task 1: application deployment with Ansible.

The implementation adds the `web_app` role. The role pulls the Docker image for the Python Moscow Time application and starts the application container on the development VM.

The development VM public IP is reused from the previous Terraform output:

```text
vm_public_ip = "111.88.243.80"
```

## Repository Structure

```text
ansible/
├── ANSIBLE.md
├── ansible.cfg
├── inventory/
│   └── default_aws_ec2.yml
├── playbooks/
│   └── dev/
│       └── main.yaml
├── requirements.yml
└── roles/
    ├── docker/
    │   ├── defaults/
    │   │   └── main.yml
    │   ├── handlers/
    │   │   └── main.yml
    │   ├── tasks/
    │   │   ├── install_compose.yml
    │   │   ├── install_docker.yml
    │   │   └── main.yml
    │   └── README.md
    └── web_app/
        ├── defaults/
        │   └── main.yml
        ├── handlers/
        │   └── main.yml
        ├── meta/
        │   └── main.yml
        ├── tasks/
        │   └── main.yml
        └── templates/
            └── docker-compose.yml.j2
```

## Inventory

Inventory file: `ansible/inventory/default_aws_ec2.yml`

```yaml
---
all:
  vars:
    ansible_python_interpreter: /usr/bin/python3
  children:
    dev:
      hosts:
        lab5_vm:
          ansible_host: 111.88.243.80
          ansible_user: ubuntu
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
```

## Role Variables

Role defaults file: `ansible/roles/web_app/defaults/main.yml`

```yaml
---
web_app_image: sadpixels/moscow-time-app:latest
web_app_container_name: moscow-time-app
web_app_host_port: 8080
web_app_container_port: 8080
web_app_restart_policy: unless-stopped
web_app_recreate_container: true
web_app_python_docker_package: python3-docker
```

Variable description:

| Variable | Description |
| --- | --- |
| `web_app_image` | Docker image pulled and deployed by the role. |
| `web_app_container_name` | Name of the application container. |
| `web_app_host_port` | Port exposed on the VM. |
| `web_app_container_port` | Port used by the application inside the container. |
| `web_app_restart_policy` | Docker restart policy for the container. |
| `web_app_recreate_container` | Recreates the container when the playbook is applied. |
| `web_app_python_docker_package` | Python Docker SDK package required by Ansible Docker modules. |

## Web Application Role Tasks

Tasks file: `ansible/roles/web_app/tasks/main.yml`

```yaml
---
- name: Ensure Docker SDK for Python is installed
  ansible.builtin.apt:
    name: "{{ web_app_python_docker_package }}"
    state: present
    update_cache: true

- name: Pull application Docker image
  community.docker.docker_image:
    name: "{{ web_app_image }}"
    source: pull

- name: Start application container
  community.docker.docker_container:
    name: "{{ web_app_container_name }}"
    image: "{{ web_app_image }}"
    state: started
    restart_policy: "{{ web_app_restart_policy }}"
    recreate: "{{ web_app_recreate_container }}"
    published_ports:
      - "{{ web_app_host_port }}:{{ web_app_container_port }}"
```

## Playbook

Playbook file: `ansible/playbooks/dev/main.yaml`

```yaml
---
- name: Deploy Docker and web application on development VM
  hosts: dev
  become: true
  gather_facts: true

  roles:
    - role: docker
    - role: web_app
```

The `docker` role is executed first to install and start Docker. The `web_app` role is executed after that to pull the application image and start the application container.

## Requirements

The deployment uses the `community.docker` Ansible collection.

Install required Ansible dependencies from the `ansible` directory:

```bash
ansible-galaxy install -r requirements.yml
```

## Deployment Command

Run the deployment from the `ansible` directory:

```bash
ansible-playbook -i inventory/default_aws_ec2.yml playbooks/dev/main.yaml --diff
```

## Running the Playbook with web-app

To deploy Docker and the application container, run:

```bash
ansible-playbook -i inventory/default_aws_ec2.yml playbooks/dev/main.yaml --diff
```

Output:

```text
PLAY [Deploy Docker and web application on development VM] *********************

TASK [Gathering Facts] *********************************************************
ok: [lab5_vm]

TASK [docker : Install Docker Engine] ******************************************
included: /home/ubuntu/DevOps-Core-Course/ansible/roles/docker/tasks/install_docker.yml for lab5_vm

TASK [docker : Validate target operating system] *******************************
ok: [lab5_vm] => {
    "changed": false,
    "msg": "Target host is Ubuntu."
}

TASK [docker : Install Docker repository prerequisites] ************************
ok: [lab5_vm]

TASK [docker : Ensure APT keyrings directory exists] ***************************
ok: [lab5_vm]

TASK [docker : Download Docker APT signing key] ********************************
ok: [lab5_vm]

TASK [docker : Set Docker APT architecture] ************************************
ok: [lab5_vm]

TASK [docker : Add Docker APT repository] **************************************
ok: [lab5_vm]

TASK [docker : Install Docker Engine packages] *********************************
ok: [lab5_vm]

TASK [docker : Enable and start Docker service] ********************************
ok: [lab5_vm]

TASK [docker : Ensure docker group exists] *************************************
ok: [lab5_vm]

TASK [docker : Add SSH user to docker group] ***********************************
ok: [lab5_vm] => (item=ubuntu)

TASK [docker : Install Docker Compose] *****************************************
included: /home/ubuntu/DevOps-Core-Course/ansible/roles/docker/tasks/install_compose.yml for lab5_vm

TASK [docker : Install Docker Compose plugin] **********************************
ok: [lab5_vm]

TASK [docker : Verify Docker Compose plugin] ***********************************
ok: [lab5_vm]

TASK [web_app : Ensure Docker SDK for Python is installed] *********************
changed: [lab5_vm]

TASK [web_app : Pull application Docker image] *********************************
changed: [lab5_vm]

TASK [web_app : Start application container] ***********************************
changed: [lab5_vm]

PLAY RECAP *********************************************************************
lab5_vm                   : ok=17   changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Validation Commands

Check that the container is running:

```bash
ssh -i ~/.ssh/id_rsa ubuntu@111.88.243.80 'docker ps --filter name=moscow-time-app'
```

Check the application endpoint:

```bash
curl http://111.88.243.80:8080
```
