# HTB Tools Module Documentation

## Overview

The `tools.py` module handles the installation and management of penetration testing tools required for Hack The Box (HTB) challenges. It provides automated tool installation with progress feedback and error handling.

## Features

- Automated installation of common pentesting tools
- Progress visualization during installation
- Error handling and logging
- Tool version management
- Dependency resolution

## Functions

### install_tools(base_dir)

Installs necessary penetration testing tools in the specified base directory.

**Parameters:**
- `base_dir`: Base directory path for tool installation

**Returns:** None

**Functionality:**
- Updates system package lists
- Installs essential pentesting tools
- Provides progress feedback during installation
- Handles installation errors gracefully
- Logs installation status

**Usage:**
```python
tools.install_tools("/path/to/machine/directory")
```

## Installed Tools

The module installs the following penetration testing tools:

### Nmap
Network discovery and security auditing tool
- Port scanning capabilities
- Service detection
- Scriptable interaction with targets

### Gobuster
Directory and file brute-forcing tool
- Fast directory enumeration
- DNS subdomain discovery
- VHOST discovery

### Nikto
Web server scanner
- Comprehensive web server testing
- Vulnerability detection
- Configuration analysis

### Hydra
Login brute-forcing tool
- Multiple protocol support
- Parallelized attacks
- Dictionary-based authentication testing

### Sqlmap
SQL injection detection and exploitation tool
- Automatic SQL injection detection
- Database fingerprinting
- Data extraction capabilities

### John the Ripper
Password cracking tool
- Multiple hash format support
- Dictionary and brute-force attacks
- GPU acceleration support

### Metasploit Framework
Penetration testing framework
- Exploit development platform
- Payload generation
- Post-exploitation tools

## Installation Process

### System Update

The installation process begins with updating system package lists:
```bash
sudo apt-get update
```

### Tool Installation

Tools are installed using the system package manager:
```bash
sudo apt-get install -y nmap gobuster nikto hydra john metasploit-framework
```

### Progress Visualization

Installation progress is displayed using loading bars:
- Each tool installation shows individual progress
- Overall installation progress is tracked
- Visual feedback provided during long operations

### Error Handling

Installation errors are handled gracefully:
- Errors are logged to the machine-specific error log
- Installation continues with remaining tools
- Users are notified of failed installations

## Integration with Other Modules

### Usage in main.py

```python
try:
    tools.install_tools(base_dir)
    error_handling.loading_bar(message="Installing tools")
except Exception as e:
    error_handling.log_error(e, "install_tools")
    error_count += 1
```

### Dependency on error_handling.py

The module uses error handling for:
- Logging installation failures
- Providing user feedback
- Tracking error counts

### Dependency on setup.py

The module uses the base directory from:
- `setup.setup_directory_structure()`

## Customization

### Adding New Tools

To add new tools to the installation list:
```python
# Add to the apt_install list
apt_install = [
    "nmap",
    "gobuster",
    "nikto",
    "hydra",
    "john",
    "metasploit-framework",
    "new-tool-name"
]
```

### Modifying Installation Commands

To customize installation commands:
```python
# Modify the installation process
install_command = f"sudo apt-get install -y {' '.join(apt_install)}"
```

### Progress Feedback

To customize progress messages:
```python
# Change loading bar message
error_handling.loading_bar(message="Installing additional tools")
```

## Troubleshooting

### Installation Failures

If tool installation fails:
- Check internet connectivity
- Verify package repository availability
- Check available disk space
- Review error logs for specific issues

### Permission Issues

If permission errors occur:
- Ensure running with appropriate privileges
- Check user sudo permissions
- Verify file system permissions

### Dependency Problems

If dependency issues arise:
- Update system packages
- Install missing dependencies manually
- Check for conflicting packages

## Best Practices

### Tool Selection

1. Include only essential tools for HTB challenges
2. Regularly update tool lists
3. Consider tool compatibility
4. Document tool purposes and usage

### Installation Process

1. Always update package lists before installation
2. Use non-interactive installation flags
3. Handle errors gracefully
4. Provide clear progress feedback

### System Management

1. Monitor disk space during installation
2. Check for conflicting packages
3. Verify tool installations
4. Document installation issues

## Verification

### Tool Installation

To verify tools are installed correctly:
```bash
# Check tool availability
which nmap
which gobuster
which nikto
```

### Installation Function

To test the installation function:
```python
# Test installation (requires appropriate environment)
import tempfile
with tempfile.TemporaryDirectory() as temp_dir:
    tools.install_tools(temp_dir)
```

### Error Handling

To verify error handling works:
```python
# Test error handling with invalid directory
try:
    tools.install_tools("/invalid/path")
except Exception as e:
    error_handling.log_error(e, "install_tools_test")
```