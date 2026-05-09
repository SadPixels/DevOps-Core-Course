# Lab 4: Infrastructure as Code

## Overview

This lab demonstrates Infrastructure as Code with Terraform. The work is split into three parts:

1. Docker infrastructure managed by Terraform.
2. Yandex Cloud infrastructure managed by Terraform.
3. GitHub repository settings managed by Terraform.

---

## Task 1: Introduction to Terraform

### Terraform installation

Terraform was installed and checked with the following command:

```bash
terraform version
```


```text
Terraform v1.14.3
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.15.1. You can update by downloading from https://developer.hashicorp.com/terraform/install
```

---

## Docker infrastructure using Terraform

### Working directory

```text
terraform/docker
```

### Files

- `versions.tf` defines the required Terraform and Docker provider versions.
- `main.tf` defines the Docker image built from `app_python/Dockerfile` and Docker container.
- `variables.tf` defines input variables, including the container name.
- `outputs.tf` defines Terraform outputs.

### Commands used

```bash
cd terraform/docker
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply
```

The Docker provider version is set to `>= 3.5.0` to avoid old Docker API client errors with newer Docker daemons. The configuration builds the existing Python application from `app_python/Dockerfile`; it does not use an unrelated nginx container.

### Applied changes log

```text

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_container.moscow_time_app will be created
  + resource "docker_container" "moscow_time_app" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (known after apply)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + memory_reservation                          = 0
      + must_run                                    = true
      + name                                        = "lab4-moscow-time-app"
      + network_data                                = (known after apply)
      + network_mode                                = "bridge"
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + healthcheck (known after apply)

      + labels (known after apply)

      + ports {
          + external = 8080
          + internal = 8080
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

  # docker_image.moscow_time_app will be created
  + resource "docker_image" "moscow_time_app" {
      + id           = (known after apply)
      + image_id     = (known after apply)
      + keep_locally = true
      + name         = "moscow-time-app:lab4-terraform"
      + repo_digest  = (known after apply)

      + build {
          + additional_contexts = []
          + cache_from          = []
          + cache_to            = []
          + context             = "/home/pixel/Documents/Study/devops/lab4/app_python"
          + dockerfile          = "Dockerfile"
          + extra_hosts         = []
          + remove              = true
          + security_opt        = []
          + tag                 = []
            # (13 unchanged attributes hidden)
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + container_id   = (known after apply)
  + container_name = "lab4-moscow-time-app"
  + container_url  = "http://localhost:8080"
  + image_name     = "moscow-time-app:lab4-terraform"

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

docker_image.moscow_time_app: Creating...
docker_image.moscow_time_app: Creation complete after 2s [id=sha256:1c166d0dcc3cd707d90f5909e45cbf1a92cb21514bdeebd757957e8dbc26c611moscow-time-app:lab4-terraform]
docker_container.moscow_time_app: Creating...
docker_container.moscow_time_app: Creation complete after 1s [id=3ae174f77723806d90ff73d1302df877e520a7d6b3656f6ff2f2213834fc7576]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

container_id = "3ae174f77723806d90ff73d1302df877e520a7d6b3656f6ff2f2213834fc7576"
container_name = "lab4-moscow-time-app"
container_url = "http://localhost:8080"
image_name = "moscow-time-app:lab4-terraform"

```

### Terraform state list

Command:

```bash
terraform state list
```

Output:

```text
docker_container.moscow_time_app
docker_image.moscow_time_app
```

### Terraform state show

Command:

```bash
terraform state show docker_container.moscow_time_app
```

Output:

```text
# docker_container.moscow_time_app:
resource "docker_container" "moscow_time_app" {
    attach                                      = false
    bridge                                      = null
    command                                     = [
        "gunicorn",
        "-b",
        "0.0.0.0:8080",
        "app:app",
    ]
    container_read_refresh_timeout_milliseconds = 15000
    cpu_set                                     = null
    cpu_shares                                  = 0
    domainname                                  = null
    entrypoint                                  = []
    env                                         = []
    hostname                                    = "3ae174f77723"
    id                                          = "3ae174f77723806d90ff73d1302df877e520a7d6b3656f6ff2f2213834fc7576"
    image                                       = "sha256:1c166d0dcc3cd707d90f5909e45cbf1a92cb21514bdeebd757957e8dbc26c611"
    init                                        = false
    ipc_mode                                    = "private"
    log_driver                                  = "json-file"
    logs                                        = false
    max_retry_count                             = 0
    memory                                      = 0
    memory_reservation                          = 0
    memory_swap                                 = 0
    must_run                                    = true
    name                                        = "lab4-moscow-time-app"
    network_data                                = [
        {
            gateway                   = "172.17.0.1"
            global_ipv6_address       = null
            global_ipv6_prefix_length = 0
            ip_address                = "172.17.0.2"
            ip_prefix_length          = 16
            ipv6_gateway              = null
            mac_address               = "c2:f1:cd:39:59:bf"
            network_name              = "bridge"
        },
    ]
    network_mode                                = "bridge"
    pid_mode                                    = null
    privileged                                  = false
    publish_all_ports                           = false
    read_only                                   = false
    remove_volumes                              = true
    restart                                     = "no"
    rm                                          = false
    runtime                                     = "runc"
    security_opts                               = []
    shm_size                                    = 64
    start                                       = true
    stdin_open                                  = false
    stop_signal                                 = null
    stop_timeout                                = 0
    tty                                         = false
    user                                        = "appuser"
    userns_mode                                 = null
    wait                                        = false
    wait_timeout                                = 60
    working_dir                                 = "/home/appuser"

    ports {
        external = 8080
        internal = 8080
        ip       = "0.0.0.0"
        protocol = "tcp"
    }
}
```

### Input variables

The Docker container name is not hardcoded directly in the resource. It is configured through the `container_name` input variable in `terraform/docker/variables.tf`.

Example:

```bash
terraform apply -var="container_name=lab4-moscow-time-app-renamed"
```

### Terraform output

Command:

```bash
terraform output
```

Output:

```text
container_id = "3ae174f77723806d90ff73d1302df877e520a7d6b3656f6ff2f2213834fc7576"
container_name = "lab4-moscow-time-app"
container_url = "http://localhost:8080"
image_name = "moscow-time-app:lab4-terraform"
```

---

## Yandex Cloud infrastructure using Terraform

### Working directory

```text
terraform/yandex
```

### Files

- `versions.tf` defines the Yandex Cloud provider.
- `main.tf` defines the network, subnet and VM.
- `variables.tf` defines input variables.
- `outputs.tf` defines useful VM outputs.

### Authentication

Yandex Cloud credentials were not placed into the Terraform code. Authentication was done through the Yandex Cloud CLI.

```bash
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

### Commands used

```bash
cd terraform/yandex
terraform init -upgrade
terraform fmt
terraform validate
terraform plan -var="cloud_id=$YC_CLOUD_ID" -var="folder_id=$YC_FOLDER_ID"
terraform apply -var="cloud_id=$YC_CLOUD_ID" -var="folder_id=$YC_FOLDER_ID"
```

### Terraform output

Command:

```bash
terraform output
```

Output:

```text
ssh_command = "ssh ubuntu@111.88.243.80"
vm_name = "lab4-terraform-vm"
vm_public_ip = "111.88.243.80"
```

### Challenges encountered

```text
During the Yandex Cloud part, Terraform expected the SSH public key at `~/.ssh/id_rsa.pub`, but this file was not present on the local machine. The issue was fixed by creating a separate SSH key specifically for this lab with the expected file name
```

---

## Terraform best practices applied

- Terraform files are organized by provider and purpose.
- Secrets and tokens are not stored in the repository.
- Terraform state files are ignored by Git.
- `.terraform/` provider cache is ignored by Git.
- Input variables are used instead of hardcoding values.
- `terraform fmt` is used for consistent formatting.
- `terraform validate` is used before applying changes.
- `terraform plan` is reviewed before `terraform apply`.
- Generated infrastructure can be destroyed with `terraform destroy` after collecting evidence for the report.



