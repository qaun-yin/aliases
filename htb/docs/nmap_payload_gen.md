# HTB Nmap and Payload Generation Module Documentation

## Overview

The `nmap_payload_gen.py` module handles network scanning with Nmap and automated payload generation based on discovered services. It provides functions for initial reconnaissance, detailed service scanning, and targeted payload creation for Hack The Box (HTB) challenges.

## Features

- Initial Nmap scanning for port discovery
- Advanced Nmap scanning with service detection
- Automated payload generation based on discovered services
- Progress visualization during scanning
- Error handling and logging
- Service-specific payload templates

## Functions

### initial_nmap_scan(machine_ip, base_dir)

Performs a quick Nmap scan to identify open ports on the target machine.

**Parameters:**
- `machine_ip`: IP address of the target machine
- `base_dir`: Base directory for storing scan results

**Returns:**
- `machine_type`: Detected machine type ("Linux" or "Windows")

**Functionality:**
- Executes Nmap scan with all ports (-p-)
- Saves results to `nmap/initial_scan.txt`
- Parses scan results to detect OS type
- Provides progress feedback during scanning
- Handles scan errors gracefully

**Usage:**
```python
machine_type = nmap_payload_gen.initial_nmap_scan("10.10.10.3", "/path/to/machine")
```

### advanced_nmap_scan(machine_ip, machine_type, base_dir)

Performs detailed Nmap scanning with service detection and script execution.

**Parameters:**
- `machine_ip`: IP address of the target machine
- `machine_type`: Detected machine type ("Linux" or "Windows")
- `base_dir`: Base directory for storing scan results

**Returns:** None

**Functionality:**
- Executes targeted Nmap scan on discovered ports
- Uses service-specific Nmap scripts
- Saves results to `nmap/advanced_scan.txt`
- Provides progress feedback during scanning
- Handles scan errors gracefully

**Usage:**
```python
nmap_payload_gen.advanced_nmap_scan("10.10.10.3", "Linux", "/path/to/machine")
```

### generate_payloads(machine_ip, machine_type, base_dir)

Generates targeted payloads based on discovered services and machine type.

**Parameters:**
- `machine_ip`: IP address of the target machine
- `machine_type`: Detected machine type ("Linux" or "Windows")
- `base_dir`: Base directory for storing payloads

**Returns:** None

**Functionality:**
- Parses advanced scan results
- Identifies open services and versions
- Generates service-specific payloads
- Creates reverse shell payloads
- Saves payloads to `payloads/generated_payloads.txt`
- Provides progress feedback during generation
- Handles payload generation errors gracefully

**Usage:**
```python
nmap_payload_gen.generate_payloads("10.10.10.3", "Linux", "/path/to/machine")
```

## Scanning Process

### Initial Scan

The initial scan performs a comprehensive port scan:
```bash
nmap -p- -oN nmap/initial_scan.txt 10.10.10.3
```

Features:
- Scans all 65535 ports
- Outputs results in normal format
- Fast scan timing (T4)
- Saves results to initial_scan.txt

### Advanced Scan

The advanced scan performs detailed service detection:
```bash
nmap -p 22,80,443 -sV -sC -oN nmap/advanced_scan.txt 10.10.10.3
```

Features:
- Scans only discovered ports
- Service version detection (-sV)
- Default script execution (-sC)
- Outputs results in normal format
- Saves results to advanced_scan.txt

### OS Detection

Machine type is detected by analyzing service banners:
- SSH service typically indicates Linux
- SMB/RDP services typically indicate Windows
- HTTP server headers may indicate OS type

## Payload Generation

### Service-Specific Payloads

Payloads are generated based on discovered services:

#### HTTP/HTTPS Services
- Web shell upload commands
- Directory traversal payloads
- SQL injection templates
- Command injection payloads

#### SSH Service
- SSH key generation commands
- SSH brute force templates
- SSH tunneling commands

#### FTP Service
- FTP upload/download commands
- Anonymous FTP access payloads
- FTP command injection templates

#### SMB Service
- SMB enumeration commands
- SMB exploit payloads
- SMB relay attack templates

#### Database Services
- SQL injection payloads
- Database enumeration commands
- Database exploitation templates

### Reverse Shell Payloads

Generated reverse shell payloads include:

#### Linux Shells
- Bash reverse shell
- Python reverse shell
- Netcat reverse shell
- Perl reverse shell

#### Windows Shells
- PowerShell reverse shell
- Python reverse shell (Windows)
- Netcat reverse shell (Windows)

### Payload Storage

Payloads are saved to `payloads/generated_payloads.txt` with:
- Service-specific sections
- Clear payload descriptions
- Ready-to-use command templates
- IP address placeholders for customization

## Integration with Other Modules

### Usage in main.py

```python
# Initial Nmap scan
try:
    machine_type = nmap_payload_gen.initial_nmap_scan(machine_ip, base_dir)
    error_handling.loading_bar(message="Running initial Nmap scan")
except Exception as e:
    error_handling.log_error(e, "initial_nmap_scan")
    error_count += 1

# Advanced Nmap scan
try:
    nmap_payload_gen.advanced_nmap_scan(machine_ip, machine_type, base_dir)
    error_handling.loading_bar(message="Running advanced Nmap scan")
except Exception as e:
    error_handling.log_error(e, "advanced_nmap_scan")
    error_count += 1

# Payload generation
try:
    nmap_payload_gen.generate_payloads(machine_ip, machine_type, base_dir)
    error_handling.loading_bar(message="Generating payloads")
except Exception as e:
    error_handling.log_error(e, "generate_payloads")
    error_count += 1
```

### Dependency on error_handling.py

The module uses error handling for:
- Logging scan failures
- Providing user feedback
- Tracking error counts

### Dependency on setup.py

The module uses directories created by:
- `setup.setup_directory_structure()`

## Customization

### Scan Parameters

To modify scan parameters:
```python
# Change scan timing
initial_scan_cmd = f"nmap -p- -T5 -oN {initial_scan_file} {machine_ip}"

# Add additional scan scripts
advanced_scan_cmd = f"nmap -p {ports} -sV -sC --script vuln -oN {advanced_scan_file} {machine_ip}"
```

### Payload Templates

To add new payload templates:
```python
# Add service-specific payloads
if "http" in service.lower():
    payloads.append("curl -X POST http://target/upload -F 'file=@shell.php'")
```

### Machine Type Detection

To customize OS detection:
```python
# Add new detection rules
if "microsoft" in banner.lower():
    return "Windows"
```

## Troubleshooting

### Scan Failures

If Nmap scans fail:
- Check target IP address
- Verify network connectivity
- Check Nmap installation
- Review error logs for specific issues

### Payload Generation Issues

If payload generation fails:
- Verify scan results exist
- Check service parsing logic
- Review payload templates
- Test with sample scan data

### Performance Problems

If scans are slow:
- Adjust scan timing parameters
- Limit port ranges for specific scans
- Use more targeted scanning approaches
- Check network bandwidth

## Best Practices

### Scanning Strategy

1. Start with quick initial scans
2. Follow with targeted detailed scans
3. Use appropriate scan timing
4. Document scan results thoroughly

### Payload Generation

1. Match payloads to discovered services
2. Include multiple payload variations
3. Provide clear usage instructions
4. Test payloads in safe environments

### Result Storage

1. Organize scan results by type
2. Include timestamps in filenames
3. Maintain clean directory structure
4. Document payload purposes

## Verification

### Scan Execution

To verify scans execute correctly:
```bash
# Test Nmap commands manually
nmap -p- -oN test_initial.txt 10.10.10.3
nmap -p 22,80 -sV -sC -oN test_advanced.txt 10.10.10.3
```

### Payload Generation

To verify payload generation:
```python
# Test with sample data
sample_services = ["22/tcp ssh", "80/tcp http"]
# Verify payloads are generated for these services
```

### Error Handling

To verify error handling:
```python
# Test with invalid IP
try:
    initial_nmap_scan("invalid.ip", "/tmp")
except Exception as e:
    log_error(e, "test_initial_nmap_scan")
```