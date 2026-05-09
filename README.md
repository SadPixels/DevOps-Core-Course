# DevOps Core Course

## Lab 5: Ansible and Docker Deployment

This repository contains the initial Ansible setup for Lab 5 Task 1.

### What is included

- Ansible project structure under `ansible/`.
- Static inventory file for a development VM.
- Development playbook for Docker deployment.
- Local `docker` wrapper role that uses the existing `geerlingguy.docker` Ansible Galaxy role.
- Placeholder `web_app` role structure for the recommended repository layout.

### Install Ansible

On Ubuntu:

```bash
sudo apt update
sudo apt install -y ansible
ansible --version
```

### Install the external Docker role

From the repository root:

```bash
cd ansible
ansible-galaxy role install -r requirements.yml -p ~/.ansible/roles
cd ..
```

### Configure inventory

Edit `ansible/inventory/default_aws_ec2.yml` and replace these values with the development VM connection details:

```yaml
ansible_host: <vm_public_ip>
ansible_user: ubuntu
ansible_ssh_private_key_file: ~/.ssh/id_rsa
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
