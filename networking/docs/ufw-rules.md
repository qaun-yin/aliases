# UFW Firewall Rules Documentation

## Overview

This document provides examples and guidance for configuring the Uncomplicated Firewall (UFW) on Ubuntu/Debian systems. UFW is a user-friendly interface to iptables that simplifies firewall configuration.

## Features

- Basic UFW commands and syntax
- Interface-specific firewall rules
- Service-specific access control
- Security best practices
- Common configuration examples

## Basic UFW Commands

### Enable/Disable Firewall

```bash
# Enable UFW
sudo ufw enable

# Disable UFW
sudo ufw disable

# Check UFW status
sudo ufw status
sudo ufw status verbose
```

### Default Policies

```bash
# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default deny forward
```

### Allow/Block Specific Ports

```bash
# Allow specific ports
sudo ufw allow 22/tcp      # SSH
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS
sudo ufw allow 53          # DNS (TCP and UDP)

# Allow port ranges
sudo ufw allow 60000:61000/udp

# Block specific ports
sudo ufw deny 80/tcp
```

### Allow/Block Specific IPs

```bash
# Allow specific IP addresses
sudo ufw allow from 192.168.1.100
sudo ufw allow from 192.168.1.0/24

# Block specific IP addresses
sudo ufw deny from 10.0.0.1
sudo ufw deny from 10.0.0.0/8
```

### Service-Based Rules

```bash
# Allow services by name
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow dns
```

## Interface-Specific Rules

### Network Interface Configuration

```bash
# Allow DNS, HTTP, and HTTPS traffic out on specific interface
sudo ufw allow out on wlan0 to 1.1.1.1 proto udp port 53 comment 'allow DNS on wlan0'
sudo ufw allow out on wlan0 to any proto tcp port 80 comment 'allow HTTP on wlan0'
sudo ufw allow out on wlan0 to any proto tcp port 443 comment 'allow HTTPS on wlan0'

# Allow specific services on internal interface
sudo ufw allow in on eth0 to any port 22 comment 'SSH on internal network'
```

### ZeroTier Network Rules

```bash
# Allow specific services on ZeroTier interface
sudo ufw allow in on zt0 to any port 22 comment 'SSH over ZeroTier'
sudo ufw allow in on zt0 to any port 80 comment 'HTTP over ZeroTier'
sudo ufw allow in on zt0 to any port 443 comment 'HTTPS over ZeroTier'
```

## Security Best Practices

### 1. Default Deny Policy

Always start with a default deny policy:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

### 2. Principle of Least Privilege

Only allow necessary services and ports:
```bash
# Instead of allowing all traffic
# sudo ufw allow 22/tcp

# Only allow from specific sources
sudo ufw allow from 192.168.1.0/24 to any port 22
```

### 3. Use Comments for Documentation

Document your rules with comments:
```bash
sudo ufw allow 22/tcp comment 'SSH access for administrators'
sudo ufw allow from 10.6.4.0/22 to any port 443 comment 'HTTPS access from ZeroTier network'
```

### 4. Regular Rule Review

Periodically review and clean up firewall rules:
```bash
# List all rules with numbers
sudo ufw status numbered

# Delete specific rules by number
sudo ufw delete 3
```

## Common Configuration Examples

### Basic Web Server

```bash
# Enable UFW
sudo ufw enable

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow essential services
sudo ufw allow ssh comment 'SSH access'
sudo ufw allow http comment 'HTTP web server'
sudo ufw allow https comment 'HTTPS web server'

# Allow DNS resolution
sudo ufw allow out 53 comment 'DNS resolution'
```

### Secure SSH Access

```bash
# Allow SSH from specific IP ranges only
sudo ufw allow from 192.168.1.0/24 to any port 22 comment 'SSH from local network'
sudo ufw allow from 10.6.4.0/22 to any port 22 comment 'SSH from ZeroTier network'

# Rate limit SSH attempts
sudo ufw limit 22/tcp comment 'Rate-limited SSH access'
```

### Docker Container Security

```bash
# Allow Docker container communication
sudo ufw allow from 172.17.0.0/16 comment 'Docker container network'

# Allow specific container ports
sudo ufw allow from 172.17.0.0/16 to any port 8080 comment 'Web application container'
```

### Network Segmentation

```bash
# Internal network rules
sudo ufw allow in on eth0 to any port 22 comment 'SSH on internal interface'
sudo ufw allow in on eth0 to any port 3306 comment 'MySQL on internal interface'

# External network rules
sudo ufw allow in on eth1 to any port 80 comment 'HTTP on external interface'
sudo ufw allow in on eth1 to any port 443 comment 'HTTPS on external interface'
```

## Advanced Configuration

### Custom Application Profiles

Create custom application profiles in `/etc/ufw/applications.d/`:

```ini
[CustomWebApp]
title=Custom Web Application
description=Web application running on ports 8080 and 8443
ports=8080,8443/tcp
```

Then use the profile:
```bash
sudo ufw allow CustomWebApp
```

### Logging Configuration

```bash
# Enable logging
sudo ufw logging on

# Set logging level
sudo ufw logging low|medium|high|full

# View logs
sudo tail -f /var/log/ufw.log
```

### IPv6 Support

Enable IPv6 support:
```bash
# In /etc/default/ufw
IPV6=yes
```

## Troubleshooting

### UFW Not Starting

Check for conflicting firewall software:
```bash
# Check if iptables rules exist
sudo iptables -L

# Flush existing rules if needed
sudo iptables -F
```

### Rules Not Working

Verify rule syntax and order:
```bash
# Check current rules
sudo ufw status verbose

# Test connectivity
nc -zv hostname port
```

### Application Connectivity Issues

Check if applications are listening on correct interfaces:
```bash
# Check listening ports
sudo netstat -tlnp | grep :port

# Check application binding
sudo ss -tlnp | grep :port
```

## Verification

### Rule Testing

Test firewall rules with network utilities:
```bash
# Test port connectivity
telnet hostname port
nc -zv hostname port

# Test from specific interface
nc -zv -s source_ip hostname port
```

### Log Analysis

Monitor firewall logs:
```bash
# View recent UFW logs
sudo tail -f /var/log/ufw.log

# Analyze blocked connections
sudo grep -i blocked /var/log/ufw.log
```

### Configuration Validation

Verify configuration consistency:
```bash
# Check UFW status
sudo ufw status verbose

# Validate rule syntax
sudo ufw status numbered
```

## Best Practices Summary

1. **Start with default deny**: Always begin with denying all incoming traffic
2. **Document rules**: Use comments to explain the purpose of each rule
3. **Regular reviews**: Periodically audit firewall rules for relevance
4. **Principle of least privilege**: Only allow necessary access
5. **Interface-specific rules**: Use interface names for precise control
6. **Logging**: Enable appropriate logging levels for monitoring
7. **Testing**: Test rules thoroughly before deployment
8. **Backups**: Keep backups of working configurations