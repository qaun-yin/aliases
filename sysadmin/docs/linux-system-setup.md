# Linux System Setup Script Documentation

## Overview

This script automates the setup and hardening of a Linux server system. It configures SSH security, sets up firewalls, installs essential tools, and performs security audits using Lynis.

## Features

- Interactive configuration prompts
- SSH security hardening
- Firewall configuration (UFW or iptables)
- System updates and upgrades
- ZeroTier network integration
- Essential package installation (Docker, TMUX, Git)
- Security auditing with Lynis
- Alias setup from GitHub repository
- Dependency checking and installation
- Disk space verification

## Requirements

- Linux-based system (Ubuntu/Debian recommended)
- Root privileges (sudo)
- Internet connectivity
- Zerotier Network ID for network integration

## Usage

```bash
sudo ./linux-system-setup.sh
```

## What the Script Does

### 1. User Configuration
Prompts for:
- SSH port (default: 22)
- Firewall choice (ufw/iptables, default: ufw)
- Zerotier Network ID
- Zerotier Network IP Address (optional)

### 2. System Preparation
- Verifies root privileges
- Checks available disk space (minimum 500MB required)
- Installs dependencies (curl, git)
- Fixes dpkg issues if present

### 3. SSH Security Hardening
- Changes SSH port to user-specified value
- Disables root login over SSH
- Disables password authentication
- Restarts SSH service

### 4. System Updates
- Updates package lists
- Upgrades all packages to latest versions

### 5. Firewall Configuration
Based on user choice:
- **UFW**: Installs and configures Uncomplicated Firewall
- **iptables**: Installs and configures iptables with persistence

### 6. Package Installation
- Installs ZeroTier VPN client
- Installs Docker container platform
- Installs TMUX terminal multiplexer
- Installs Git version control
- Joins specified ZeroTier network

### 7. Security Auditing
- Installs Lynis security auditing tool
- Performs comprehensive system audit
- Identifies critical vulnerabilities
- Offers automated remediation options

### 8. Alias Setup
- Clones the aliases repository from GitHub
- Copies bash_aliases to user home directory
- Sources the updated configuration

## Security Features

### SSH Hardening
- Custom SSH port configuration
- Root login disabled
- Password authentication disabled
- Key-based authentication enforced

### Firewall Protection
- Configurable firewall selection
- SSH port whitelisting
- Default deny policy

### Security Auditing
- Automated Lynis security scans
- Critical vulnerability detection
- Automated remediation options

### Package Management
- Automatic dependency installation
- System update and upgrade
- Dpkg issue resolution

## Configuration Options

### SSH Port
Customize the SSH port for improved security through obscurity.

### Firewall Selection
Choose between:
- **UFW**: User-friendly firewall management
- **iptables**: Low-level packet filtering

### ZeroTier Integration
- Join existing ZeroTier networks
- Assign static IP addresses within networks

## Troubleshooting

### Permission Issues

If you encounter permission errors:
```bash
sudo ./linux-system-setup.sh
```

### Disk Space Issues

If the script reports insufficient disk space:
- Free up space using system cleanup tools
- Remove unnecessary packages: `sudo apt-get autoremove`
- Clear package cache: `sudo apt-get clean`

### Dependency Installation Failures

If package installation fails:
- Check internet connectivity
- Verify package repositories: `sudo apt-get update`
- Manually install dependencies:
  ```bash
  sudo apt-get install curl git
  ```

### SSH Configuration Issues

If SSH access is lost after configuration:
- Connect via console access if available
- Check SSH configuration: `sudo nano /etc/ssh/sshd_config`
- Restart SSH service: `sudo systemctl restart sshd`

### Firewall Issues

If firewall blocks access:
- Check firewall status: `sudo ufw status` (for UFW)
- Allow additional ports as needed: `sudo ufw allow PORT/tcp`

## Customization

### Package Installation

To modify installed packages, edit the `install_packages` function:
```bash
# Add or remove packages as needed
apt-get install -y package1 package2 package3
```

### Security Remediation

To customize security remediation, modify the `remediate_lynis_issues` function:
```bash
# Add additional security measures
# Example: Configure fail2ban, set up automatic updates, etc.
```

### Alias Repository

To use a different alias repository:
```bash
# Modify the repository URL in setup_aliases function
git clone https://github.com/yourusername/your-repo.git
```

## Verification

### SSH Configuration

To verify SSH settings:
```bash
sudo sshd -T | grep -E "(port|permitrootlogin|passwordauthentication)"
```

### Firewall Status

For UFW:
```bash
sudo ufw status verbose
```

For iptables:
```bash
sudo iptables -L
```

### Package Installation

To verify installed packages:
```bash
dpkg -l | grep -E "(docker|tmux|git|zerotier)"
```

### ZeroTier Status

To check ZeroTier connection:
```bash
zerotier-cli info
zerotier-cli listnetworks
```

## Best Practices

1. **Backup Configuration**: Always backup existing configurations before running
2. **Test SSH Access**: Verify SSH access before disconnecting from the server
3. **Firewall Rules**: Ensure necessary ports are open for your services
4. **ZeroTier Authorization**: Remember to authorize the device in ZeroTier Central
5. **Security Updates**: Regularly run system updates for security patches
6. **Lynis Audits**: Schedule regular Lynis audits for ongoing security monitoring

## Recovery

If the system becomes inaccessible:
- Use out-of-band management (IPMI, iDRAC, etc.) if available
- Boot from rescue media
- Restore from backups
- Revert firewall rules if needed