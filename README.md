# My on-the-go toolkit 

This repo is meant to be a quick setup kit for terminal users and sys/net admin related work.
Feel free to fork or create a PR to contribute!

## Table of Contents

- [Aliases](#aliases)
- [Installation Scripts](#installation-scripts)
- [Networking](#networking)
- [System Administration](#system-administration)
- [Development Tools](#development-tools)
- [Hack The Box (HTB)](#hack-the-box-htb)
- [TAK (Team Awareness Kit)](#tak-team-awareness-kit)
- [StackScripts](#stackscripts)
- [Usage](#usage)

## Aliases

The `.bash_aliases` file contains useful shortcuts for:

- **System Administration**: Update, upgrade, clean, reboot, shutdown commands
- **Networking**: IP configuration, ping, traceroute, DNS lookups, UFW firewall
- **Git**: Common git commands (status, add, commit, push, pull, clone)
- **Docker**: Docker and docker-compose shortcuts
- **TMUX**: Terminal multiplexer session management
- **ZeroTier**: VPN network management

### Installing Aliases

```bash
# Copy the bash_aliases file to your home directory
cp bash_aliases ~/.bash_aliases

# Reload your bash configuration
source ~/.bashrc
```

## Installation Scripts

Located in `install-scripts/`, these scripts automate the installation and configuration of various tools:

### Container & Orchestration
- **docker-install.sh** - Install Docker CE
- **docker-deb-install.sh** - Install Docker from Debian packages
- **lazydocker-install.sh** - Install LazyDocker (terminal UI for Docker)
- **rancher-install.sh** - Install Rancher for Kubernetes management
- **helm-install.sh** - Install Helm package manager

### Networking & VPN
- **zerotier-install.sh** - Install ZeroTier VPN client
- **zerotier-conf.sh** - Configure ZeroTier networks
- **tailscale_manager.sh** - Manage Tailscale VPN

### Development Tools
- **git_setup.sh** - Configure Git with user details
- **setup_dev_enviornment.sh** - Set up a complete development environment
- **tmux-install.sh** - Install and configure TMUX

### Web & Security
- **nginx_setup.sh** - Install and configure Nginx
- **brave-browser.sh** - Install Brave browser
- **wazuh_wizard.sh** - Install and configure Wazuh security platform
- **teleport-install.sh** - Install Teleport access platform
- **wireshark-install.sh** - Install Wireshark network analyzer

### Gaming & AI
- **minecraft-install.sh** - Set up Minecraft server with Docker & ZeroTier
- **autogpt-install.sh** - Install AutoGPT
- **whisper.sh** - Install OpenAI Whisper

### Radio & SDR
- **rtl-sdr.sh** - Complete RTL-SDR setup with multiple SDR tools

### Other
- **usb-key-setup.sh** - Set up USB keys with various configurations

### Usage

```bash
cd install-scripts
chmod +x <script-name>.sh
./<script-name>.sh
```

## Networking

The `networking/` directory contains configuration examples and documentation:

- **example-advanced.nginx.conf** - Advanced Nginx configuration
- **ufw-rules.md** - UFW firewall rule examples
- **zerotier-default-ethernet.md** - ZeroTier ethernet bridge configuration

## System Administration

The `sysadmin/` directory contains system administration tools:

- **c-mgmt.py** - Python tool for container management
- **usb-helper.sh** - USB device management helper
- **disable-services.md** - Guide for disabling unnecessary services
- **linux-system-setup.sh** - Automated Linux system setup
- **wazuh-rules.md** - Wazuh security rules documentation

### Usage

```bash
cd sysadmin
chmod +x <script-name>.sh
./<script-name>.sh
```

## Development Tools

The `dev/` directory contains development-related resources:

- **terraform/** - Terraform configurations for infrastructure
  - **dev-server.md** - Development server setup guide

## Hack The Box (HTB)

The `htb/` directory contains Python tools for penetration testing:

- **main.py** - Main orchestration script
- **setup.py** - Environment setup
- **tools.py** - Various penetration testing tools
- **nmap_payload_gen.py** - Nmap payload generator
- **error_handling.py** - Error handling utilities

### Usage

```bash
cd htb
python3 main.py
```

## TAK (Team Awareness Kit)

The `tak/` directory contains scripts and documentation for TAK setup:

- **setup_tak.sh** - Automated TAK environment setup with tmux
- **tak_setup.py** - Python-based TAK configuration
- **docker.md** - Docker configuration for TAK
- **tak-server.md** - TAK server setup guide
- **tak-client.md** - TAK client setup guide
- **zerotier.md** - ZeroTier integration with TAK
- **tailscale.md** - Tailscale integration with TAK

### Usage

```bash
cd tak
chmod +x setup_tak.sh
./setup_tak.sh
```

## StackScripts

The `stackscripts/` directory contains Linode StackScripts for automated server provisioning:

### Dev Server
- Pre-configured development server setup

### Web Server
- **provision.sh** - Web server provisioning script

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/cywf/aliases.git
   cd aliases
   ```

2. **Install aliases:**
   ```bash
   cp bash_aliases ~/.bash_aliases
   source ~/.bashrc
   ```

3. **Run installation scripts as needed:**
   ```bash
   cd install-scripts
   chmod +x docker-install.sh
   ./docker-install.sh
   ```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. When contributing:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

See [LICENSE](LICENSE) file for details.

## Support

For issues, questions, or contributions, please open an issue on GitHub.
