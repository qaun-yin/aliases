# Development Server StackScript

This StackScript automates the setup of a development server environment on Linode. It installs essential development tools, configures security settings, and prepares the system for development work.

## Overview

The development server StackScript creates a ready-to-use development environment with:

- System updates and security hardening
- Essential development tools (Git, Docker, etc.)
- User environment configuration
- Network security setup

## Features

### System Configuration
- Automatic system updates
- Security hardening measures
- Firewall configuration with UFW
- User account setup with sudo privileges

### Development Tools
- Git installation and configuration
- Docker installation with compose plugin
- Common build tools and utilities
- Text editors (vim, nano)

### Security
- SSH hardening
- Fail2ban installation and configuration
- Automatic security updates
- Log monitoring setup

## Usage

To use this StackScript:

1. Create a Linode account
2. Navigate to the StackScripts section
3. Create a new StackScript using the provision.sh content
4. Deploy a new Linode using this StackScript

### Parameters

This StackScript accepts the following parameters:

- **username**: The username for the primary user account
- **password**: The password for the primary user account
- **ssh_key**: Public SSH key for secure access

## Configuration

### System Updates

The script automatically updates the system and installs security patches:

```bash
apt-get update
apt-get upgrade -y
```

### User Setup

Creates a primary user account with sudo privileges:

```bash
adduser ${USERNAME}
usermod -aG sudo ${USERNAME}
```

### SSH Configuration

Hardens SSH security by:

- Disabling root login
- Changing the default SSH port
- Enabling key-based authentication only

### Firewall Setup

Configures UFW with essential rules:

```bash
ufw default deny incoming
ufw default allow outgoing
ufw allow ${SSH_PORT}/tcp
ufw enable
```

## Examples

### Basic Deployment

1. Create a new Linode
2. Select this StackScript
3. Provide required parameters:
   - username: developer
   - password: [secure password]
   - ssh_key: [your public key]
4. Deploy the Linode

### Post-Deployment Access

After deployment, access your server:

```bash
ssh developer@your-linode-ip
```

The server will be ready for development work with all essential tools installed.

## Troubleshooting

### Common Issues

1. **SSH Connection Issues**
   - Verify SSH key format
   - Check firewall rules
   - Confirm SSH port configuration

2. **Package Installation Failures**
   - Check internet connectivity
   - Verify package repository availability
   - Review system logs

3. **User Account Problems**
   - Verify username and password parameters
   - Check user creation logs
   - Confirm sudo privileges

### Getting Help

If you encounter issues not covered in this documentation:

1. Check the Linode StackScript documentation
2. Review system logs in /var/log/
3. Open an issue on GitHub with detailed information
4. Include error messages and deployment parameters