# Docker Role

This role is used for Lab 5 Task 1. It is a local wrapper around the existing `geerlingguy.docker` Ansible Galaxy role.

## Requirements

- Ansible installed on the control node.
- SSH access to the managed Ubuntu VM.
- `geerlingguy.docker` installed with:

```bash
cd ansible
ansible-galaxy role install -r requirements.yml -p ~/.ansible/roles
```

## Role Variables

- `docker_role_install_compose_plugin`: enables Docker Compose plugin installation through the Galaxy role. Default: `true`.
- `docker_role_users`: users added to the Docker group by the Galaxy role. Default: `ansible_user`.
- `docker_role_verify_compose`: runs `docker compose version` after deployment. Default: `true`.

## Example Playbook

```yaml
---
- name: Deploy Docker on development VM
  hosts: dev
  become: true
  roles:
    - role: docker
```
