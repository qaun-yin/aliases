# HTB Setup Module Documentation

## Overview

The `setup.py` module handles environment setup and user input collection for Hack The Box (HTB) automation tools. It provides functions for gathering machine information from users and creating organized directory structures for each HTB challenge.

## Features

- Interactive user input collection
- Directory structure creation
- Machine information validation
- Base environment setup
- User-friendly prompts

## Functions

### get_user_input()

Collects machine information from the user through interactive prompts.

**Parameters:** None

**Returns:**
- `handle`: Machine handle from HTB
- `machine_name`: Machine name
- `machine_ip`: Machine IP address
- `machine_type`: Machine type (Linux/Windows) or empty for auto-detection

**Functionality:**
- Prompts user for HTB machine handle
- Prompts user for machine name
- Prompts user for machine IP address
- Optionally prompts for machine type
- Validates IP address format

**Usage:**
```python
handle, machine_name, machine_ip, machine_type = setup.get_user_input()
```

### setup_directory_structure(machine_name)

Creates an organized directory structure for the specified machine.

**Parameters:**
- `machine_name`: Name of the machine to create directories for

**Returns:**
- `base_dir`: Path to the created base directory

**Functionality:**
- Creates machine-specific directory
- Creates subdirectories for different tool outputs:
  - `nmap/`: Nmap scan results
  - `payloads/`: Generated payloads
- Ensures all directories exist
- Returns base directory path

**Usage:**
```python
base_dir = setup.setup_directory_structure("lame")
```

## Directory Structure

The setup module creates the following directory structure:

```
machine_name/
├── nmap/
│   ├── initial_scan.txt
│   └── advanced_scan.txt
├── payloads/
│   └── generated_payloads.txt
└── error_log.txt
```

### nmap/
Directory for storing Nmap scan results:
- `initial_scan.txt`: Results from quick port scan
- `advanced_scan.txt`: Results from detailed service scan

### payloads/
Directory for storing generated payloads:
- `generated_payloads.txt`: Payloads generated based on discovered services

### error_log.txt
Error log file for recording any issues during execution.

## User Input Collection

### HTB Machine Handle

Prompt: "Enter the machine's HackTheBox handle: "
- Example: "Lame"
- Used for reference and documentation

### Machine Name

Prompt: "Enter the machine's name: "
- Example: "lame"
- Used for directory naming
- Should be lowercase and hyphenated if needed

### Machine IP Address

Prompt: "Enter the machine's IP address: "
- Example: "10.10.10.3"
- Validated for proper IP format
- Used for scanning and payload generation

### Machine Type

Prompt: "Enter the machine's type (Linux/Windows) or leave blank for auto-detection: "
- Optional field
- If provided, must be "Linux" or "Windows"
- If blank, auto-detection will be performed

## Validation

### IP Address Validation

The module validates IP addresses using regex pattern matching:
- Ensures format is XXX.XXX.XXX.XXX
- Validates each octet is between 0-255
- Provides feedback for invalid addresses

### Directory Creation

Directory creation includes:
- Checking for existing directories
- Creating parent directories as needed
- Handling permission errors
- Providing clear success/failure messages

## Integration with Other Modules

### Usage in main.py

```python
# Get user input
handle, machine_name, machine_ip, machine_type = setup.get_user_input()

# Setup directory structure
base_dir = setup.setup_directory_structure(machine_name)
```

## Customization

### Directory Structure

To modify the directory structure, update the `setup_directory_structure` function:
```python
# Add new directories
os.makedirs(os.path.join(base_dir, "exploits"), exist_ok=True)
os.makedirs(os.path.join(base_dir, "notes"), exist_ok=True)
```

### Input Prompts

To customize input prompts, modify the `get_user_input` function:
```python
# Change prompt text
handle = input("Enter HTB machine identifier: ")
```

### Validation Rules

To modify validation rules, update the IP address validation:
```python
# Add additional validation
if not re.match(r'^(\d{1,3}\.){3}\d{1,3}$', machine_ip):
    # Custom validation logic
```

## Troubleshooting

### Directory Creation Issues

If directories fail to create:
- Check filesystem permissions
- Verify sufficient disk space
- Ensure parent directories exist

### Input Validation Problems

If input validation fails:
- Check regex patterns
- Verify user input format
- Test with various input values

### User Experience Issues

If prompts are unclear:
- Review prompt text for clarity
- Add examples to prompts
- Provide better error messages

## Best Practices

### Directory Organization

1. Use consistent naming conventions
2. Create logical directory hierarchies
3. Include README files for complex structures
4. Document directory purposes

### User Input

1. Provide clear instructions
2. Include examples in prompts
3. Validate all user input
4. Handle edge cases gracefully

### Error Handling

1. Always check for directory creation success
2. Handle permission errors appropriately
3. Provide meaningful error messages
4. Log errors for debugging

## Verification

### Directory Creation

To verify directory creation works:
```python
# Test directory creation
base_dir = setup.setup_directory_structure("test-machine")
assert os.path.exists(base_dir)
assert os.path.exists(os.path.join(base_dir, "nmap"))
assert os.path.exists(os.path.join(base_dir, "payloads"))
```

### Input Collection

To verify input collection works:
```python
# Test input collection (requires user interaction)
handle, machine_name, machine_ip, machine_type = setup.get_user_input()
assert isinstance(handle, str)
assert isinstance(machine_name, str)
assert isinstance(machine_ip, str)
```