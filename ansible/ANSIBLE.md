# Lab 5: Ansible Deployment Notes

## Scope

This document describes the Ansible work for Lab 5 Task 1 and Task 2.

Task 1 created the Ansible project structure, inventory and Docker deployment playbook. Task 2 replaced the initial Docker role wrapper with a custom `docker` role that installs Docker Engine, installs Docker Compose, enables Docker on boot and adds the SSH user to the `docker` group.

The VM public IP was taken from the Lab 4 Terraform output:

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

## Check Connection to Server

Command:

```bash
ansible -i inventory/default_aws_ec2.yml dev -m ping
```

Output:

```text
lab5_vm | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## Inventory Graph Output

Command:

```bash
ansible-inventory -i inventory/default_aws_ec2.yml --graph
```

Output:

```text
@all:
  |--@ungrouped:
  |--@dev:
  |  |--lab5_vm
```

## Inventory List Output

Command:

```bash
ansible-inventory -i inventory/default_aws_ec2.yml --list
```

Output:

```json
{
    "_meta": {
        "hostvars": {
            "lab5_vm": {
                "ansible_host": "111.88.243.80",
                "ansible_python_interpreter": "/usr/bin/python3",
                "ansible_ssh_private_key_file": "~/.ssh/id_rsa",
                "ansible_user": "ubuntu"
            }
        }
    },
    "all": {
        "children": [
            "ungrouped",
            "dev"
        ]
    },
    "dev": {
        "hosts": [
            "lab5_vm"
        ]
    }
}
```

## Playbook

Playbook file: `ansible/playbooks/dev/main.yaml`

```yaml
---
- name: Deploy Docker on development VM
  hosts: dev
  become: true
  gather_facts: true

  roles:
    - role: docker
```

## Dry Run

Command:

```bash
ansible-playbook -i inventory/default_aws_ec2.yml playbooks/dev/main.yaml --check --diff
```

Output:

```text
PLAY [Deploy Docker on development VM] *****************************************

TASK [Gathering Facts] *********************************************************
ok: [lab5_vm]

TASK [docker : Validate target operating system] *******************************
ok: [lab5_vm] => {
    "changed": false,
    "msg": "Target host is Ubuntu."
}

TASK [docker : Install Docker repository prerequisites] ************************
changed: [lab5_vm]

TASK [docker : Ensure APT keyrings directory exists] ***************************
ok: [lab5_vm]

TASK [docker : Download Docker APT signing key] ********************************
changed: [lab5_vm]

TASK [docker : Set Docker APT architecture] ************************************
ok: [lab5_vm]

TASK [docker : Add Docker APT repository] **************************************
changed: [lab5_vm]

TASK [docker : Install Docker Engine packages] *********************************
changed: [lab5_vm]

TASK [docker : Enable and start Docker service] ********************************
changed: [lab5_vm]

TASK [docker : Ensure docker group exists] *************************************
changed: [lab5_vm]

TASK [docker : Add SSH user to docker group] ***********************************
skipping: [lab5_vm] => (item=ubuntu)

TASK [docker : Install Docker Compose plugin] **********************************
changed: [lab5_vm]

TASK [docker : Verify Docker Compose plugin] ***********************************
skipping: [lab5_vm]

PLAY RECAP *********************************************************************
lab5_vm                   : ok=10   changed=7    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```

## Running the Playbook

Command:

```bash
ansible-playbook -i inventory/default_aws_ec2.yml playbooks/dev/main.yaml --diff
```

## Last 50 Lines of Deployment Output

```text
TASK [Gathering Facts] *********************************************************
ok: [lab5_vm]

TASK [docker : Validate target operating system] *******************************
ok: [lab5_vm] => {
    "changed": false,
    "msg": "Target host is Ubuntu."
}

TASK [docker : Install Docker repository prerequisites] ************************
changed: [lab5_vm]

TASK [docker : Ensure APT keyrings directory exists] ***************************
ok: [lab5_vm]

TASK [docker : Download Docker APT signing key] ********************************
changed: [lab5_vm]

TASK [docker : Set Docker APT architecture] ************************************
ok: [lab5_vm]

TASK [docker : Add Docker APT repository] **************************************
changed: [lab5_vm]

TASK [docker : Install Docker Engine packages] *********************************
changed: [lab5_vm]

RUNNING HANDLER [docker : restart docker] **************************************
changed: [lab5_vm]

TASK [docker : Enable and start Docker service] ********************************
ok: [lab5_vm]

TASK [docker : Ensure docker group exists] *************************************
ok: [lab5_vm]

TASK [docker : Add SSH user to docker group] ***********************************
changed: [lab5_vm] => (item=ubuntu)

TASK [docker : Install Docker Compose plugin] **********************************
changed: [lab5_vm]

TASK [docker : Verify Docker Compose plugin] ***********************************
ok: [lab5_vm]

PLAY RECAP *********************************************************************
lab5_vm                   : ok=12   changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Validation Commands

Run from the `ansible` directory:

```bash
ansible -i inventory/default_aws_ec2.yml dev -m ping
ansible-inventory -i inventory/default_aws_ec2.yml --graph
ansible-inventory -i inventory/default_aws_ec2.yml --list
ansible-playbook -i inventory/default_aws_ec2.yml playbooks/dev/main.yaml --check --diff
ansible-playbook -i inventory/default_aws_ec2.yml playbooks/dev/main.yaml --diff
```

## Notes

After adding `ubuntu` to the `docker` group, a new SSH session is required before Docker commands work without `sudo` for that user.
