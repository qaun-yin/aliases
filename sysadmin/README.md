# System Administration Tools

This directory contains tools and documentation for system administration tasks. These scripts help with container management, service configuration, system setup, and security hardening.

## Table of Contents

- [Python Tools](#python-tools)
- [Shell Scripts](#shell-scripts)
- [Documentation](#documentation)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)

## Python Tools

### c-mgmt.py

A Python tool for container management that provides a simplified interface for common Docker operations.

**Requirements:**

- Python 3.6+
- Docker already installed
- docker-py Python package

**Features:**

- List running containers
- Start/stop containers
- Remove containers and images
- View container logs
- Execute commands in containers

**Usage:**

```bash
python3 c-mgmt.py [list|start|stop|remove|logs|exec] [container-name] [command]
```

**Examples:**

```bash
# List all containers
python3 c-mgmt.py list

# Stop a container
python3 c-mgmt.py stop my-container

# View container logs
python3 c-mgmt.py logs my-container

# Execute a command in a container
python3 c-mgmt.py exec my-container "ls -la"
```

## Shell Scripts

### usb-helper.sh

USB device management helper that provides utilities for working with USB devices.

**Requirements:**

- Ubuntu/Debian-based system
- sudo privileges
- lsusb utility

**Features:**

- List connected USB devices
- Identify USB device information
- Mount/unmount USB devices
- Format USB devices

**Usage:**

```bash
chmod +x usb-helper.sh
./usb-helper.sh [list|info|mount|unmount|format] [device]
```

### linux-system-setup.sh

Automated Linux system setup that configures a new system with common settings and tools.

**Requirements:**

- Ubuntu/Debian-based system
- Internet connectivity
- sudo privileges

**Features:**

- Update system packages
- Install common utilities
- Configure system settings
- Set up user environment

**Usage:**

```bash
chmod +x linux-system-setup.sh
./linux-system-setup.sh
```

## Documentation

### disable-services.md

Guide for disabling unnecessary services to improve system security and performance.

**Content:**

- Instructions for disabling CUPS printing services
- Instructions for disabling Avahi daemon
- Security implications of disabling services
- Commands for removing services entirely

**Usage:**
Read the document for detailed instructions on disabling specific services.

### wazuh-rules.md

Wazuh security rules documentation that explains how to configure and customize Wazuh security rules.

**Content:**

- Overview of Wazuh rules structure
- Examples of custom rules
- Rule testing procedures
- Best practices for rule creation

**Usage:**
Refer to this document when configuring Wazuh security rules.

## Usage

Most scripts in this directory require execution permissions:

```bash
chmod +x script-name.sh
./script-name.sh
```

Python scripts can be executed directly:

```bash
python3 script-name.py [arguments]
```

## Troubleshooting

### Common Issues

1. **Permission Denied Errors**
   - Ensure you have appropriate permissions
   - Run scripts with `sudo` if required

2. **Python Module Missing**
   - Install required Python packages with `pip install`

3. **Service Not Found**
   - Verify service names are correct
   - Check if services are installed

### Getting Help

If you encounter issues not covered in this documentation:

1. Check the specific script header for detailed information
2. Refer to the documentation files for detailed instructions
3. Open an issue on GitHub with detailed information
4. Include error messages and system information
