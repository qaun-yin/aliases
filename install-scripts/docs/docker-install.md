# Docker Installation Script Documentation

## Overview

This script automates the installation and configuration of Docker CE on Ubuntu/Debian systems. It handles the complete installation process including repository setup, package installation, post-installation configuration, and service management.

## Features

- Removes old Docker versions
- Sets up official Docker repository
- Installs Docker CE with all necessary components
- Configures Docker to start on boot
- Adds user to docker group for non-sudo usage
- Sets up proper permissions
- Configures logging drivers

## Requirements

- Ubuntu/Debian-based system
- Internet connectivity
- sudo privileges

## Usage

```bash
chmod +x docker-install.sh
./docker-install.sh
```

## What the Script Does

1. **Repository Setup**
   - Removes old Docker versions
   - Updates package index
   - Installs required dependencies
   - Adds Docker's official GPG key
   - Sets up the stable repository

2. **Package Installation**
   - Updates package index
   - Installs Docker Engine, Containerd, and Docker Compose plugin

3. **Post-Installation Configuration**
   - Creates docker group
   - Adds current user to docker group
   - Configures Docker to start on boot
   - Provides guidance for permission issues

4. **Logging Configuration**
   - Information about configuring logging drivers to prevent disk exhaustion

## Troubleshooting

### GPG Errors

If you receive GPG errors when running update:
```bash
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update
```

### Permission Denied Errors

If you see permission errors after adding your user to the docker group:
```bash
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
```

### Verification

After installation, verify Docker is working:
```bash
docker run hello-world
```

## Security Considerations

- Adding users to the docker group grants them root-level privileges
- Consider the security implications in multi-user environments
- Review logging configuration to prevent disk space issues

## Customization

The script can be customized by modifying:
- Repository URL for different distributions
- Package versions for specific requirements
- Logging driver configuration for different environments