# NGINX Setup Script Documentation

## Overview

This script automates the installation and configuration of NGINX web server with SSL support. It configures virtual hosts, sets up SSL certificates, and integrates with ZeroTier networking. The script also provides options to install additional tools like Certbot, Docker, and ZeroTier.

## Features

- Automated NGINX installation
- Virtual host configuration with SSL support
- ZeroTier network integration
- Optional tool installation (Certbot, Docker, ZeroTier)
- DNS configuration guidance
- Interactive setup wizard

## Requirements

- Ubuntu/Debian-based system
- Root privileges (sudo)
- Internet connectivity
- ZeroTier network membership (optional)

## Usage

```bash
sudo ./nginx_setup.sh
```

## What the Script Does

1. **Environment Check**
   - Verifies the script is run as root
   - Prompts for domain and network details

2. **NGINX Installation**
   - Updates package index
   - Installs NGINX web server

3. **Configuration**
   - Creates virtual host configuration
   - Sets up SSL certificate paths
   - Configures security settings
   - Restricts access to ZeroTier network

4. **Service Management**
   - Tests NGINX configuration
   - Restarts NGINX service

5. **Optional Tools**
   - Installs Certbot for Let's Encrypt SSL certificates
   - Installs Docker container platform
   - Installs ZeroTier networking tool

6. **Guidance**
   - Provides DNS update instructions
   - Shows dashboard access information

## Configuration Details

### Virtual Host Setup

The script creates a virtual host configuration with:
- SSL/TLS encryption
- HTTP/2 support
- Proxy pass to localhost applications
- WebSocket support for real-time applications
- Network access restrictions

### Security Features

- SSL protocol configuration (TLSv1.2 and TLSv1.3)
- Strong cipher suite selection
- ZeroTier network access restriction
- Proxy header configuration

## Optional Tool Installation

The script offers to install:
1. **Certbot**: For Let's Encrypt SSL certificates
2. **Docker**: Container platform
3. **ZeroTier**: Virtual networking tool

## Troubleshooting

### NGINX Configuration Errors

If the configuration test fails:
- Check domain names are correct
- Verify ZeroTier IP address
- Ensure certificate paths exist

### Service Issues

To manually restart NGINX:
```bash
sudo systemctl restart nginx
```

To check NGINX status:
```bash
sudo systemctl status nginx
```

### SSL Certificate Issues

After obtaining SSL certificates with Certbot:
- Update certificate paths in the configuration
- Restart NGINX service

## Customization

The script can be customized by modifying:
- Domain name prompts
- ZeroTier network restrictions
- SSL certificate paths
- Proxy pass configurations
- Optional tool selections