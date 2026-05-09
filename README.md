# DevOps Core Course

## Lab 6: Ansible Application Deployment

This repository contains the Ansible setup for Lab 6 Task 1.

### What is included

- Ansible project structure under `ansible/`.
- Static inventory file for the development VM.
- Custom `docker` Ansible role from Lab 5.
- `web_app` role for application deployment.
- Docker image pull task.
- Docker container start task.
- Development playbook that runs `docker` first and `web_app` second.
- Ansible documentation in `ansible/ANSIBLE.md`.

### Install Ansible dependencies

Run from the `ansible` directory:

```bash
ansible-galaxy install -r requirements.yml
```

### Configure inventory

The inventory is located at:

```text
ansible/inventory/default_aws_ec2.yml
```

Current VM public IP:

```text
111.88.243.80
```

### Validate inventory

Run Ansible commands from the `ansible` directory so that `ansible.cfg` is applied:

```bash
cd ansible
ansible-inventory -i inventory/default_aws_ec2.yml --graph
ansible-inventory -i inventory/default_aws_ec2.yml --list
```

### Deploy application

```bash
ansible-playbook -i inventory/default_aws_ec2.yml playbooks/dev/main.yaml --diff
```

### Validate application

```bash
curl http://111.88.243.80:8080
```
