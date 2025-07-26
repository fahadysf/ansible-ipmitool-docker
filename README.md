# Ansible IPMITOOL Docker

[![Docker Pulls](https://img.shields.io/docker/pulls/fahadysf/ansible-ipmitool)](https://hub.docker.com/r/fahadysf/ansible-ipmitool)
[![Docker Image Size](https://img.shields.io/docker/image-size/fahadysf/ansible-ipmitool/latest)](https://hub.docker.com/r/fahadysf/ansible-ipmitool)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/fahadysf/ansible-ipmitool-docker/docker-build.yml?branch=main)](https://github.com/fahadysf/ansible-ipmitool-docker/actions)
[![License](https://img.shields.io/github/license/fahadysf/ansible-ipmitool-docker)](https://github.com/fahadysf/ansible-ipmitool-docker/blob/main/LICENSE)

A lightweight Alpine Linux-based Docker image with Ansible and IPMITOOL pre-installed. Perfect for automating IPMI-based server management tasks.

## Features

- **Alpine Linux 3.22** - Minimal base image for smaller footprint
- **Ansible** - Latest stable version for automation
- **IPMITOOL** - For IPMI management tasks
- **Python 3** - With pip for additional package installation
- **OpenSSH Client** - For SSH connectivity required by Ansible

## Quick Start

### Pull from Docker Hub

```bash
docker pull fahadysf/ansible-ipmitool:latest
```

### Pull from GitHub Container Registry

```bash
docker pull ghcr.io/fahadysf/ansible-ipmitool:latest
```

### Run Interactive Shell

```bash
docker run -it --rm fahadysf/ansible-ipmitool:latest
```

### Run Ansible Playbook

```bash
docker run -it --rm \
  -v $(pwd)/playbooks:/ansible \
  fahadysf/ansible-ipmitool:latest \
  ansible-playbook playbook.yml
```

### Run IPMITOOL Command

```bash
docker run -it --rm \
  fahadysf/ansible-ipmitool:latest \
  ipmitool -I lanplus -H <server-ip> -U <username> -P <password> power status
```

## Usage Examples

### Example 1: Ansible Inventory with IPMI

Create an inventory file (`inventory.yml`):

```yaml
all:
  hosts:
    server1:
      ansible_host: 10.0.0.10
      ipmi_host: 10.0.0.110
      ipmi_user: ADMIN
      ipmi_password: !vault |
        $ANSIBLE_VAULT;1.1;AES256
        ...
```

### Example 2: Ansible Playbook for IPMI Control

Create a playbook (`ipmi-control.yml`):

```yaml
---
- name: IPMI Server Management
  hosts: all
  gather_facts: no
  tasks:
    - name: Check server power status
      command: >
        ipmitool -I lanplus 
        -H {{ ipmi_host }} 
        -U {{ ipmi_user }} 
        -P {{ ipmi_password }} 
        power status
      register: power_status

    - name: Display power status
      debug:
        var: power_status.stdout
```

Run the playbook:

```bash
docker run -it --rm \
  -v $(pwd):/ansible \
  fahadysf/ansible-ipmitool:latest \
  ansible-playbook -i inventory.yml ipmi-control.yml
```

### Example 3: Using with Docker Compose

Create a `docker-compose.yml`:

```yaml
version: '3.8'
services:
  ansible-ipmi:
    image: fahadysf/ansible-ipmitool:latest
    volumes:
      - ./playbooks:/ansible
      - ./inventory:/inventory
    environment:
      - ANSIBLE_HOST_KEY_CHECKING=False
    command: ansible-playbook -i /inventory/hosts.yml /ansible/site.yml
```

## Building from Source

```bash
git clone https://github.com/fahadysf/ansible-ipmitool-docker.git
cd ansible-ipmitool-docker
docker build -t fahadysf/ansible-ipmitool:latest .
```

## Environment Variables

You can pass any Ansible environment variables to the container:

```bash
docker run -it --rm \
  -e ANSIBLE_HOST_KEY_CHECKING=False \
  -e ANSIBLE_TIMEOUT=30 \
  fahadysf/ansible-ipmitool:latest
```

## Volumes

- `/ansible` - Default working directory for Ansible playbooks and configurations

## Available Tags

- `latest` - Latest stable build from main branch
- `main` - Latest build from main branch
- `<branch-name>` - Builds from specific branches
- `<version>` - Specific version tags (when released)

## Security Considerations

- Never hardcode IPMI credentials in your playbooks
- Use Ansible Vault for sensitive data
- Consider using environment variables for credentials
- Run containers with minimal privileges

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/fahadysf/ansible-ipmitool-docker/issues) page
2. Create a new issue if your problem isn't already listed
3. Provide detailed information about your use case

## Acknowledgments

- Alpine Linux team for the minimal base image
- Ansible community for the automation framework
- IPMITOOL developers for the IPMI management utility