# Container Management (C-MGMT) Script Documentation

## Overview

C-MGMT (Container Management Wizard) is a comprehensive Python script for managing Docker containers and related resources. It provides multiple modes including backup, update, removal, and status reporting functions with environment-aware auto-detection.

## Features

- Environment-aware auto-detection (Canvas/CLI mode)
- Container backup functionality
- Container update management
- Comprehensive resource removal (containers, images, volumes, networks)
- Status reporting
- Self-testing capabilities
- Non-interactive mode support
- Job management with background processing
- Visual feedback with colored output

## Requirements

- Python 3.6+
- Docker installed and accessible
- Appropriate permissions for Docker operations

## Usage

```bash
python3 c-mgmt.py
```

## Command Line Options

```bash
# Run in interactive mode
python3 c-mgmt.py

# Run self-tests
python3 c-mgmt.py --self-test

# Export report (future feature)
python3 c-mgmt.py --export txt|json
```

## Environment Detection

The script automatically detects the execution environment:

### CLI Mode
- Full wizard interface
- Requires Docker installation
- Interactive menus
- Full feature set

### Canvas Mode
- Safe verification only
- Self-tests and status reporting
- Non-interactive environments
- Limited feature set

## Modes of Operation

### 1. Backup Mode
Placeholder for container backup functionality.

### 2. Updater Mode
Placeholder for container update management.

### 3. Remover Mode
Comprehensive resource cleanup:
- Stops all containers
- Removes all containers
- Removes all images
- Removes all volumes
- Removes all networks
- Prunes the system

**Warning**: This operation is destructive and cannot be undone.

### 4. Status Mode
Placeholder for status reporting functionality.

### 5. Exit
Quits the application.

## Self-Testing

The script includes self-tests to verify functionality:
- Non-interactive menu defaulting
- Safe input fallback
- Return code validation without SystemExit

Run self-tests:
```bash
python3 c-mgmt.py --self-test
```

## Job Management

Background job processing:
- Asynchronous command execution
- Job logging and status tracking
- Persistent job storage

## Security Considerations

- Requires Docker permissions
- Destructive operations in Remover Mode
- Environment detection for safe operation
- Non-interactive mode for automated environments

## Troubleshooting

### Docker Not Found

If Docker is not installed or not accessible:
- Install Docker: `sudo apt-get install docker.io`
- Start Docker service: `sudo systemctl start docker`
- Add user to docker group: `sudo usermod -aG docker $USER`

### Permission Issues

If you encounter permission issues:
- Verify Docker service is running
- Check user group membership
- Run with sudo if necessary

### Environment Detection Problems

If environment detection fails:
- Force CLI mode: `CMGMT_ENV=cli python3 c-mgmt.py`
- Force Canvas mode: `CMGMT_ENV=canvas python3 c-mgmt.py`

## Customization

### Environment Variables

- `CMGMT_ENV`: Force environment mode (cli/canvas)
- `CMGMT_FORCE_NONINTERACTIVE`: Force non-interactive mode
- `CMGMT_EXIT`: Allow SystemExit in Canvas mode
- `CMGMT_ROOT`: Set custom root directory

### Configuration Files

The script uses the following directories:
- `/mnt/data/cmgmt`: Primary data directory
- `/tmp/cmgmt`: Fallback data directory
- `./cmgmt_data`: Local data directory

## Verification

To verify the script is working correctly:

1. Run self-tests:
   ```bash
   python3 c-mgmt.py --self-test
   ```

2. Check status in Canvas mode:
   ```bash
   python3 c-mgmt.py
   ```

3. Run in CLI mode:
   ```bash
   CMGMT_ENV=cli python3 c-mgmt.py
   ```