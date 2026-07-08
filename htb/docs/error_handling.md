# HTB Error Handling Module Documentation

## Overview

The `error_handling.py` module provides comprehensive error handling and logging functionality for the Hack The Box (HTB) automation tools. It includes exception handling, error logging, and user-friendly progress visualization.

## Features

- Exception handling for all HTB operations
- Error logging to file with timestamp and context
- Loading bar visualization for user feedback
- Error count tracking
- Detailed error information preservation

## Functions

### log_error(error, function_name)

Logs errors to a file with detailed context information.

**Parameters:**
- `error`: The exception object
- `function_name`: Name of the function where the error occurred

**Functionality:**
- Creates timestamped error entries
- Logs error type and message
- Records function context
- Appends to error_log.txt file

**Usage:**
```python
try:
    # Some operation
    pass
except Exception as e:
    error_handling.log_error(e, "function_name")
```

### loading_bar(message)

Displays a visual progress indicator to the user.

**Parameters:**
- `message`: Status message to display

**Functionality:**
- Shows animated progress dots
- Provides real-time feedback
- Enhances user experience during long operations
- Clears line after completion

**Usage:**
```python
error_handling.loading_bar("Scanning target machine")
```

## Error Logging

### Log File Location

Errors are logged to `error_log.txt` in the machine-specific directory.

### Log Format

Each error entry includes:
- Timestamp of the error
- Function where error occurred
- Error type
- Error message

Example log entry:
```
[2026-07-08 15:30:45] Error in initial_nmap_scan: subprocess.CalledProcessError
Command '['nmap', '-p-', '-oN', 'nmap/initial_scan.txt', '10.10.10.3']' returned non-zero exit status 2.
```

## Loading Bar Visualization

### Animation

The loading bar displays a sequence of dots to indicate progress:
```
Scanning target machine.... done.
```

### Timing

- Updates every 0.15 seconds
- Runs for approximately 1.5 seconds total
- Provides visual feedback during operations

## Integration with Other Modules

### Usage in setup.py

```python
try:
    # Setup operations
    pass
except Exception as e:
    error_handling.log_error(e, "setup_directory_structure")
    error_count += 1
```

### Usage in tools.py

```python
try:
    # Tool installation
    pass
except Exception as e:
    error_handling.log_error(e, "install_tools")
    error_count += 1
```

### Usage in nmap_payload_gen.py

```python
try:
    # Nmap scanning
    pass
except Exception as e:
    error_handling.log_error(e, "initial_nmap_scan")
    error_count += 1
```

## Customization

### Error Log File

To change the error log file name, modify the `log_error` function:
```python
ERROR_LOG_FILE = "custom_error_log.txt"
```

### Loading Bar Animation

To customize the loading bar animation, modify the `loading_bar` function:
```python
# Change animation characters
spin = '|/-\\'  # Can be customized

# Change delay timing
delay = 0.15   # In seconds
```

## Troubleshooting

### Log File Issues

If error logs are not being created:
- Check directory permissions
- Verify file system space
- Ensure the base directory exists

### Loading Bar Problems

If loading bar doesn't display correctly:
- Check terminal compatibility
- Verify stdout is not redirected
- Test in different terminal emulators

## Best Practices

### Error Handling

1. Always wrap operations in try-except blocks
2. Log specific function names for context
3. Handle different exception types appropriately
4. Provide meaningful error messages to users

### Progress Visualization

1. Use loading bars for operations longer than 1 second
2. Provide clear status messages
3. Keep messages concise but informative
4. Update loading bars at regular intervals

### Log Management

1. Regularly review error logs
2. Implement log rotation for large files
3. Include relevant context in log entries
4. Preserve logs for debugging purposes

## Verification

### Error Logging

To verify error logging works:
```python
# Test error logging
try:
    raise Exception("Test error")
except Exception as e:
    log_error(e, "test_function")
```

Check that `error_log.txt` contains the entry.

### Loading Bar

To verify loading bar works:
```python
# Test loading bar
loading_bar("Test message")
```

Observe the animated progress indicator.