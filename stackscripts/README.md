# StackScripts

This directory contains Linode StackScripts for automated server provisioning. StackScripts are shell scripts that run automatically when a Linode is created, allowing for automated configuration and software installation.

## Table of Contents

- [Overview](#overview)
- [Dev Server](#dev-server)
- [Web Server](#web-server)
- [Usage](#usage)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

## Overview

Linode StackScripts provide a way to automate server provisioning and configuration. These scripts can install software, configure services, and set up environments automatically when a new Linode is created.

Each StackScript directory contains:

- **provision.sh**: The main provisioning script
- **README.md**: Documentation for the specific StackScript

## Dev Server

Pre-configured development server setup for creating a ready-to-use development environment.

**Features:**

- System updates and security hardening
- Development tool installation (Git, Docker, etc.)
- User environment configuration
- Network security setup

**Components:**

- Automated package installation
- User account configuration
- Service management
- Security configuration

## Web Server

Web server provisioning script for creating a production-ready web server environment.

**Features:**

- Web server installation (Nginx/Apache)
- SSL certificate configuration
- Security hardening
- Performance optimization

**Components:**

- Web server installation and configuration
- SSL certificate management
- Firewall configuration
- Monitoring setup

## Usage

To use these StackScripts:

1. Create a Linode account
2. Navigate to the StackScripts section
3. Create a new StackScript using the provision.sh content
4. Deploy a new Linode using the StackScript

## Examples

### Creating a StackScript

1. Log into your Linode account
2. Go to StackScripts in the sidebar
3. Click "Create StackScript"
4. Paste the contents of provision.sh
5. Add required parameters if any
6. Save the StackScript

### Deploying with StackScript

1. Create a new Linode
2. Select your custom StackScript
3. Configure Linode settings (type, region, etc.)
4. Deploy the Linode
5. The StackScript will run automatically during provisioning

## Troubleshooting

### Common Issues

1. **Script Execution Failures**
   - Check script syntax
   - Verify package names are correct
   - Ensure proper permissions

2. **Network Configuration Issues**
   - Verify firewall rules
   - Check DNS configuration
   - Confirm network interfaces

3. **Service Startup Problems**
   - Check service status
   - Review system logs
   - Verify dependencies

### Getting Help

If you encounter issues not covered in this documentation:

1. Check the specific StackScript documentation
2. Review Linode StackScript documentation
3. Open an issue on GitHub with detailed information
4. Include error messages and system information
