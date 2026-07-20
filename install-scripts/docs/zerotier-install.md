# ZeroTier Installation Script Documentation

## Overview

This script automates the installation of ZeroTier VPN client. It downloads and verifies the official ZeroTier installation script using GPG signatures, then executes the installation.

## Features

- Secure download of official ZeroTier installation script
- GPG signature verification for security
- Automated installation process
- Minimal dependencies required

## Requirements

- Linux-based system (Ubuntu/Debian, CentOS/RHEL, etc.)
- Internet connectivity
- curl and gpg utilities
- sudo privileges

## Usage

```bash
chmod +x zerotier-install.sh
./zerotier-install.sh
```

## What the Script Does

1. **GPG Key Import**
   - Downloads and imports the official ZeroTier GPG key
   - Verifies the authenticity of the installation script

2. **Script Download and Verification**
   - Downloads the official installation script from zerotier.com
   - Verifies the script signature using the imported GPG key

3. **Installation Execution**
   - Executes the verified installation script with sudo privileges
   - Installs ZeroTier One service

## Post-Installation Steps

After installation, you need to:

1. **Start the ZeroTier service**:
   ```bash
   sudo systemctl start zerotier-one
   ```

2. **Enable the service to start on boot**:
   ```bash
   sudo systemctl enable zerotier-one
   ```

3. **Join a network**:
   ```bash
   sudo zerotier-cli join NETWORK_ID
   ```

4. **Check service status**:
   ```bash
   sudo systemctl status zerotier-one
   ```

## Security Features

- **GPG Verification**: Ensures the installation script hasn't been tampered with
- **Official Source**: Downloads directly from zerotier.com
- **Signature Checking**: Validates script authenticity before execution

## Troubleshooting

### GPG Import Issues

If the GPG key import fails:
- Check internet connectivity
- Verify the key URL is accessible
- Manually import the key:
  ```bash
  curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import
  ```

### Installation Script Download Failures

If the script download fails:
- Check firewall settings
- Verify curl is installed
- Manually download and verify:
  ```bash
  curl -s 'https://install.zerotier.com/' | gpg
  ```

### Service Management Issues

If the service fails to start:
- Check system logs: `sudo journalctl -u zerotier-one`
- Verify installation: `which zerotier-cli`
- Restart the service: `sudo systemctl restart zerotier-one`

## Network Management

### Joining Networks

To join a ZeroTier network:
```bash
sudo zerotier-cli join NETWORK_ID
```

### Listing Networks

To list joined networks:
```bash
sudo zerotier-cli listnetworks
```

### Leaving Networks

To leave a network:
```bash
sudo zerotier-cli leave NETWORK_ID
```

## Customization

The script uses the official installation method. For custom installations, you can:

1. **Manual Installation**:
   - Download packages directly from ZeroTier
   - Install using package managers (apt, yum, etc.)

2. **Custom Network Configuration**:
   - Modify network settings in `/var/lib/zerotier-one/`
   - Configure local.conf for advanced settings

## Verification

To verify the installation:

1. Check the service status:
   ```bash
   sudo systemctl status zerotier-one
   ```

2. Verify the CLI tool:
   ```bash
   zerotier-cli info
   ```

3. Check the installed version:
   ```bash
   zerotier-cli version
   ```