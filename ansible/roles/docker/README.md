# Docker Role

This role installs and configures Docker Engine and Docker Compose on an Ubuntu VM.

## Requirements

- Ansible 2.9+
- Ubuntu 22.04 or compatible Ubuntu-based VM
- SSH access to the target host
- Privilege escalation with `sudo`

## Role Variables

| Variable | Default | Description |
| --- | --- | --- |
| `docker_version` | `latest` | Controls Docker package state. `latest` installs the latest available Docker packages from the Docker APT repository. |
| `docker_compose_version` | `latest` | Controls Docker Compose plugin package state. `latest` installs the latest available package. |
| `docker_users` | `ansible_user` | Users added to the `docker` group to run Docker commands without `sudo` after a new login session. |
| `docker_service_name` | `docker` | Docker systemd service name. |
| `docker_apt_gpg_key_url` | Docker official Ubuntu GPG key URL | Docker APT signing key URL. |
| `docker_apt_keyring_path` | `/etc/apt/keyrings/docker.asc` | Local path for the Docker APT signing key. |
| `docker_packages` | Docker Engine packages | Packages installed for Docker Engine and Buildx. |
| `docker_compose_package` | `docker-compose-plugin` | Package used to install Docker Compose v2 plugin. |

## Tasks

The role performs the following actions:

1. Installs required APT packages.
2. Adds the Docker APT signing key.
3. Adds the Docker APT repository.
4. Installs Docker Engine packages.
5. Installs Docker Compose plugin.
6. Enables and starts the Docker service on boot.
7. Ensures the `docker` group exists.
8. Adds the SSH user to the `docker` group.
9. Verifies Docker Compose with `docker compose version` outside check mode.

## Example Playbook

```yaml
---
- name: Deploy Docker on development VM
  hosts: dev
  become: true
  roles:
    - role: docker
```

## Usage

From the `ansible` directory:

```bash
ansible-playbook -i inventory/default_aws_ec2.yml playbooks/dev/main.yaml --check --diff
ansible-playbook -i inventory/default_aws_ec2.yml playbooks/dev/main.yaml --diff
```

After the role adds the user to the `docker` group, reconnect over SSH before running Docker without `sudo`.
