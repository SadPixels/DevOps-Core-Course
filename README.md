# DevOps Core Course

## Lab 5: Ansible and Docker Deployment

This repository contains the Ansible setup for Lab 5 Task 1 and Task 2.

### What is included

- Ansible project structure under `ansible/`.
- Static inventory file for the development VM.
- Development playbook for Docker deployment.
- Custom `docker` Ansible role.
- Docker Engine installation tasks.
- Docker Compose plugin installation task.
- Docker service enablement on boot.
- Docker group configuration for the SSH user.
- Ansible documentation in `ansible/ANSIBLE.md`.
- Placeholder `web_app` role structure for the recommended repository layout.

### Install Ansible

On Ubuntu:

```bash
sudo apt update
sudo apt install -y ansible
ansible --version
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

### Test the playbook

Dry run:

```bash
ansible-playbook -i inventory/default_aws_ec2.yml playbooks/dev/main.yaml --check --diff
```

Apply changes:

```bash
ansible-playbook -i inventory/default_aws_ec2.yml playbooks/dev/main.yaml --diff
```

### Docker access without sudo

The custom role adds the SSH user to the `docker` group. Reconnect over SSH after deployment before running Docker commands without `sudo`.
