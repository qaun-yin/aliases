# USB Helper Script Documentation

## Overview

This script provides utilities for managing USB devices on Linux systems. It offers two main functionalities: extending system storage using USB devices and writing Ubuntu Server images directly to USB drives for bootable installations.

## Features

- USB device detection and listing
- System storage extension using USB devices
- Direct streaming of Ubuntu Server images to USB drives
- Dependency checking and installation
- Disk space verification and cleanup
- Progress visualization with loading bars
- Checkpoint/resume functionality
- Root privilege enforcement

## Requirements

- Linux-based system (Ubuntu/Debian recommended)
- Root privileges (sudo)
- Internet connectivity (for dependency installation)
- USB devices for operations

## Usage

```bash
sudo ./usb-helper.sh
```

## What the Script Does

### 1. Environment Setup
- Verifies root privileges
- Checks for required dependencies
- Installs missing tools if needed
- Verifies available disk space

### 2. USB Device Detection
- Lists all available USB devices
- Shows device details (name, size, filesystem, label, mount point)

### 3. Main Menu Options

#### Option 1: Extend Current Storage
- Formats selected USB device as ext4
- Mounts the device at `/mnt/usb_storage`
- Reassigns temporary directories to use the USB storage:
  - `/tmp` directory
  - `/var/cache/apt` directory

#### Option 2: Write Ubuntu Server Image to USB
- Downloads and streams Ubuntu Server 24.04.1 LTS directly to USB
- Bypasses intermediate storage for efficiency
- Provides real-time progress feedback

## Dependencies

The script requires the following tools:
- `lsblk`: For listing block devices
- `mkfs.ext4`: For formatting devices as ext4
- `dd`: For writing images to devices
- `curl`: For downloading images

The script will automatically install missing dependencies after user confirmation.

## Security Considerations

- **Root Privileges Required**: The script must be run with sudo or as root
- **Data Loss Warning**: Writing images to USB devices will destroy all existing data
- **Device Verification**: Always verify the correct device is selected before proceeding
- **Checkpoint System**: Progress is saved to resume interrupted operations

## Troubleshooting

### Permission Issues

If you encounter permission errors:
```bash
sudo ./usb-helper.sh
```

### Device Not Found

If your USB device is not detected:
- Ensure the device is properly connected
- Check device detection with: `lsblk`
- Verify the device path exists: `ls -la /dev/sd*`

### Insufficient Disk Space

If dependency installation fails due to space constraints:
- The script will attempt to free space from cache and temp directories
- You may need to manually free additional space

### Image Download Failures

If the Ubuntu image download fails:
- Check internet connectivity
- Verify the download URL is accessible
- Retry the operation

## Customization

### Ubuntu Version

To use a different Ubuntu version, modify the URL:
```bash
UBUNTU_URL="https://releases.ubuntu.com/XX.XX/ubuntu-XX.XX-live-server-amd64.iso"
```

### Mount Point

To change the mount point for extended storage:
```bash
MOUNT_POINT="/your/custom/path"
```

### Temporary Directories

To modify which directories are reassigned:
Edit the `extend_storage` function to include additional paths.

## Verification

### Device Listing

To manually list USB devices:
```bash
lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT | grep -v "sr0" | grep -E "^sd"
```

### Mount Verification

To check if the USB device is properly mounted:
```bash
mount | grep usb_storage
```

### Space Usage

To verify space usage on the USB device:
```bash
df -h /mnt/usb_storage
```

## Best Practices

1. **Always backup important data** before using this script
2. **Verify device selection** to avoid data loss on wrong devices
3. **Ensure stable power supply** during long operations
4. **Monitor system resources** during image downloads
5. **Test bootable USBs** before using them for installations

## Recovery

If operations are interrupted:
- The script saves checkpoints to `/tmp/usb_helper_checkpoint`
- Run the script again to resume from the last checkpoint
- Manually clear checkpoints if needed: `rm /tmp/usb_helper_checkpoint`