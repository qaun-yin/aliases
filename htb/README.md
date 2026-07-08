# Hack The Box (HTB) Tools

This directory contains Python tools for penetration testing and Hack The Box challenges. These scripts automate the process of setting up environments, scanning targets, and generating payloads.

## Table of Contents

- [Overview](#overview)
- [Scripts](#scripts)
- [Usage](#usage)
- [Examples](#examples)
- [Requirements](#requirements)
- [Troubleshooting](#troubleshooting)

## Overview

The HTB tools provide an automated workflow for penetration testing activities:

1. **Environment Setup**: Create organized directory structures for each machine
2. **Tool Installation**: Automatically install necessary penetration testing tools
3. **Network Scanning**: Perform Nmap scans to identify open ports and services
4. **Payload Generation**: Generate targeted payloads based on discovered services
5. **Error Handling**: Comprehensive error logging and handling

## Scripts

### main.py

Main orchestration script that integrates all functionalities.

**Features:**

- User input collection
- Directory structure setup
- Tool installation coordination
- Nmap scanning coordination
- Payload generation coordination

**Usage:**

```bash
python3 main.py
```

### setup.py

Environment setup functions for HTB challenges.

**Features:**

- User input collection for machine details
- Directory structure creation
- Base environment configuration

**Functions:**

- `get_user_input()`: Collects machine handle, name, IP, and type
- `setup_directory_structure(machine_name)`: Creates organized directory structure

### tools.py

Tool installation functions for penetration testing.

**Features:**

- Automated installation of common pentesting tools
- Tool version management
- Dependency resolution

**Functions:**

- `install_tools(base_dir)`: Installs necessary tools in the environment

### nmap_payload_gen.py

Nmap scanning and payload generation functions.

**Features:**

- Initial Nmap scanning for service discovery
- Advanced Nmap scanning with targeted scripts
- Payload generation for discovered services
- Output organization and logging

**Functions:**

- `initial_nmap_scan(machine_ip, base_dir)`: Quick scan to identify open ports
- `advanced_nmap_scan(machine_ip, machine_type, base_dir)`: Detailed service scanning
- `generate_payloads(machine_ip, machine_type, base_dir)`: Generate targeted payloads

### error_handling.py

Error handling and logging functions.

**Features:**

- Exception handling for all operations
- Error logging to file
- User-friendly error messages
- Loading bar visualization

**Functions:**

- `log_error(error, function_name)`: Log errors to error_log.txt
- `loading_bar(message)`: Display progress visualization

## Usage

To use the HTB tools:

1. Ensure all requirements are installed
2. Run the main script:

   ```bash
   python3 main.py
   ```

3. Follow the prompts to enter machine details
4. Monitor progress through the loading bars
5. Review generated files in the machine-specific directory

## Examples

### Basic Usage

```bash
# Run the main script
python3 main.py

# Example interaction:
# Enter the machine's HackTheBox handle: Lame
# Enter the machine's name: lame
# Enter the machine's IP address: 10.10.10.3
# Enter the machine's type (Linux/Windows) or leave blank for auto-detection: 

# The script will then:
# 1. Create a directory structure for "lame"
# 2. Install necessary tools
# 3. Perform Nmap scans
# 4. Generate payloads
# 5. Log any errors to error_log.txt
```

### Directory Structure

The tools create an organized directory structure:

```
lame/
├── nmap/
│   ├── initial_scan.txt
│   └── advanced_scan.txt
├── payloads/
│   └── generated_payloads.txt
└── error_log.txt
```

## Requirements

- Python 3.6+
- Internet connectivity
- sudo privileges (for tool installation)
- Nmap installed
- Common pentesting tools (automatically installed by tools.py)

## Troubleshooting

### Common Issues

1. **Permission Denied Errors**
   - Run with appropriate privileges
   - Check tool installation permissions

2. **Nmap Scan Failures**
   - Verify target IP address
   - Check network connectivity
   - Ensure Nmap is properly installed

3. **Payload Generation Errors**
   - Verify service detection
   - Check tool availability
   - Review error logs for details

### Getting Help

If you encounter issues not covered in this documentation:

1. Check the error_log.txt file for detailed error information
2. Verify all requirements are properly installed
3. Consult official documentation for Nmap and other tools
4. Open an issue on GitHub with detailed information
5. Include error messages and system information
