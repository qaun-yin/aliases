# Team Awareness Kit (TAK) Setup

This directory contains scripts and documentation for setting up and configuring Team Awareness Kit (TAK) environments. TAK is a situational awareness platform used for coordination and communication in various operational contexts.

## Table of Contents

- [Overview](#overview)
- [Setup Scripts](#setup-scripts)
- [Documentation](#documentation)
- [Usage](#usage)
- [Examples](#examples)
- [Requirements](#requirements)
- [Troubleshooting](#troubleshooting)

## Overview

The TAK setup tools provide automated configuration for TAK server and client environments with integrated networking solutions. The tools include:

1. **Automated Installation**: Scripts to install TAK dependencies
2. **Environment Configuration**: Pre-configured tmux sessions for monitoring
3. **Networking Integration**: Support for ZeroTier and Tailscale VPNs
4. **Docker Configuration**: Containerized TAK deployments
5. **Documentation**: Comprehensive guides for setup and troubleshooting

## Setup Scripts

### setup_tak.sh

Automated TAK environment setup with tmux session management.

**Features:**

- Dependency checking and installation (tmux, Docker)
- Docker service management
- Pre-configured tmux session with monitoring tools
- 2×2 grid layout for efficient multitasking

**Components:**

- System dependency checks
- Automated package installation
- Docker service management
- tmux session creation with monitoring tools

**Usage:**

```bash
chmod +x setup_tak.sh
./setup_tak.sh
```

**tmux Layout:**

```
┌─────────────┬─────────────┐
│   Shell     │    htop     │
├─────────────┼─────────────┤
│    btop     │   syslog    │
└─────────────┴─────────────┘
```

### tak_setup.py

Python-based TAK configuration script with advanced setup options.

**Features:**

- Interactive setup wizard
- Configuration file management
- Service status monitoring
- Advanced networking options

**Usage:**

```bash
python3 tak_setup.py
```

## Documentation

### tak-server.md

TAK server setup guide with detailed installation and configuration instructions.

**Content:**

- Server installation procedures
- Configuration file management
- Service management
- Security considerations

### tak-client.md

TAK client setup guide for configuring TAK client applications.

**Content:**

- Client installation procedures
- Connection configuration
- Certificate management
- Troubleshooting common issues

### docker.md

Docker configuration for TAK deployments with containerized environments.

**Content:**

- Docker installation for TAK
- Container configuration
- Volume management
- Network configuration

### zerotier.md

ZeroTier integration with TAK for secure networking.

**Content:**

- ZeroTier installation
- Network creation and management
- TAK integration procedures
- Security best practices

### tailscale.md

Tailscale integration with TAK for alternative VPN solution.

**Content:**

- Tailscale installation
- Network configuration
- TAK integration procedures
- Comparison with ZeroTier

## Usage

To set up a TAK environment:

1. Ensure all requirements are met
2. Choose the appropriate setup method:
   - For basic setup: `./setup_tak.sh`
   - For advanced configuration: `python3 tak_setup.py`
3. Follow the interactive prompts
4. Review the tmux session layout
5. Refer to documentation for specific configurations

## Examples

### Basic TAK Setup

```bash
# Make the script executable
chmod +x setup_tak.sh

# Run the setup script
./setup_tak.sh

# The script will:
# 1. Check for tmux and Docker
# 2. Install missing dependencies
# 3. Start Docker service if needed
# 4. Create a tmux session with monitoring tools
# 5. Attach to the session
```

### Advanced Configuration

```bash
# Run the Python setup script
python3 tak_setup.py

# Follow the interactive wizard:
# 1. Configure server/client settings
# 2. Set up networking options
# 3. Configure services
# 4. Review and apply configuration
```

### tmux Session Management

```bash
# Detach from tmux session (inside tmux)
Ctrl+B, then D

# Reattach to session
tmux attach-session -t tak_setup

# List sessions
tmux list-sessions

# Kill session
tmux kill-session -t tak_setup
```

## Requirements

- Ubuntu/Debian-based system (recommended)
- Internet connectivity
- sudo privileges
- Minimum 4GB RAM
- Docker (automatically installed if missing)
- tmux (automatically installed if missing)

## Troubleshooting

### Common Issues

1. **Dependency Installation Failures**
   - Check internet connectivity
   - Verify package manager availability
   - Manually install dependencies if needed

2. **Docker Service Issues**
   - Check Docker installation
   - Verify service status with `systemctl status docker`
   - Restart service if needed

3. **tmux Session Problems**
   - Verify tmux installation
   - Check session status with `tmux list-sessions`
   - Kill and recreate session if needed

### Getting Help

If you encounter issues not covered in this documentation:

1. Check the specific script output for error messages
2. Refer to the detailed documentation files
3. Consult official TAK documentation
4. Open an issue on GitHub with detailed information
5. Include error messages and system information
