# Networking Configuration

This directory contains configuration examples and documentation for networking tasks. These files help with firewall configuration, VPN setup, and network service configuration.

## Table of Contents

- [Configuration Files](#configuration-files)
- [Documentation](#documentation)
- [Usage](#usage)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

## Configuration Files

### example-advanced.nginx.conf

Advanced Nginx configuration example that demonstrates complex routing, SSL termination, and security headers.

**Features:**

- SSL/TLS configuration with strong ciphers
- Security headers for XSS and clickjacking protection
- Rate limiting
- Gzip compression
- Custom error pages
- Reverse proxy configuration

**Usage:**
Copy to `/etc/nginx/sites-available/` and create a symlink to `/etc/nginx/sites-enabled/`:

```bash
sudo cp example-advanced.nginx.conf /etc/nginx/sites-available/advanced-config
sudo ln -s /etc/nginx/sites-available/advanced-config /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## Documentation

### ufw-rules.md

UFW firewall rule examples that demonstrate how to configure the Uncomplicated Firewall for common scenarios.

**Content:**

- Basic UFW commands
- Interface-specific rules
- Service-specific rules
- Security best practices

**Examples:**

```bash
# Allow DNS, HTTP, and HTTPS traffic out on specific interface
sudo ufw allow out on wlan0 to 1.1.1.1 proto udp port 53 comment 'allow DNS on wlan0'
sudo ufw allow out on wlan0 to any proto tcp port 80 comment 'allow HTTP on wlan0'
sudo ufw allow out on wlan0 to any proto tcp port 443 comment 'allow HTTPS on wlan0'

# General security rules
sudo ufw default deny incoming
sudo ufw default deny forward
sudo ufw default deny outgoing
```

### zerotier-default-ethernet.md

ZeroTier ethernet bridge configuration that explains how to set up layer 2 bridging with ZeroTier networks.

**Content:**

- Bridge configuration overview
- System requirements
- Step-by-step setup instructions
- Troubleshooting common issues

**Requirements:**

- ZeroTier already installed
- Bridge utilities (`bridge-utils` or `iproute2`)
- sudo privileges

## Usage

Configuration files can be copied to appropriate system directories:

```bash
sudo cp example-advanced.nginx.conf /etc/nginx/sites-available/
```

Documentation files should be read for implementation guidance.

## Examples

### Basic UFW Setup

```bash
# Enable UFW
sudo ufw enable

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow ssh

# Allow HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Check status
sudo ufw status verbose
```

### ZeroTier Bridge Configuration

```bash
# Join network
sudo zerotier-cli join NETWORK_ID

# Create bridge
sudo brctl addbr br0

# Add interfaces to bridge
sudo brctl addif br0 eth0
sudo brctl addif br0 zt0

# Bring up bridge
sudo ip link set br0 up
```

## Troubleshooting

### Common Issues

1. **Firewall Rules Not Working**
   - Check rule order (first match wins)
   - Verify interface names
   - Ensure UFW is enabled

2. **Nginx Configuration Errors**
   - Test configuration with `nginx -t`
   - Check syntax and file paths
   - Verify service status with `systemctl status nginx`

3. **ZeroTier Bridge Issues**
   - Verify network membership
   - Check interface status
   - Ensure bridge utilities are installed

### Getting Help

If you encounter issues not covered in this documentation:

1. Check the specific configuration file comments for guidance
2. Refer to the documentation files for detailed instructions
3. Consult official documentation for the tools being configured
4. Open an issue on GitHub with detailed information
5. Include error messages and system information
