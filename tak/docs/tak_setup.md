# TAK Setup Script Documentation

## Overview

The `tak_setup.py` script provides a comprehensive Python-based setup wizard for configuring Team Awareness Kit (TAK) environments. It offers interactive configuration, automated installation, and advanced setup options for both TAK servers and clients.

## Features

- Interactive setup wizard with guided configuration
- Automated TAK component installation
- Advanced networking configuration (ZeroTier, Tailscale)
- Service management and monitoring
- Configuration file generation
- System requirement validation
- Progress visualization and logging

## Script Components

### Main Setup Wizard

The core wizard provides:
- Interactive user interface
- Configuration option selection
- Progress tracking and visualization
- Error handling and recovery
- Logging and audit trail

### Installation Manager

Automated installation features:
- Dependency checking and installation
- Component version management
- Package repository configuration
- Installation progress monitoring

### Configuration Generator

Configuration management includes:
- Template-based configuration generation
- Parameter validation and substitution
- File permission management
- Backup and rollback capabilities

### Network Manager

Networking features include:
- ZeroTier integration and configuration
- Tailscale setup and management
- Network interface detection
- Port and firewall configuration

## Usage

### Basic Execution

Run the setup script:
```bash
python3 tak_setup.py
```

### Command Line Options

```bash
# Run with verbose logging
python3 tak_setup.py --verbose

# Skip interactive prompts (use defaults)
python3 tak_setup.py --non-interactive

# Specify configuration file
python3 tak_setup.py --config config.json

# Perform only installation
python3 tak_setup.py --install-only

# Validate configuration without installation
python3 tak_setup.py --validate-only
```

## Setup Process

### 1. Environment Detection

The script automatically detects:
- Operating system and version
- Available system resources (CPU, memory, disk)
- Existing TAK installations
- Network interface configuration
- Installed dependencies

### 2. Interactive Configuration

Guided setup process:
1. **System Requirements Check**
   - Verify minimum system requirements
   - Check available disk space
   - Validate network connectivity

2. **Installation Type Selection**
   - Server installation
   - Client installation
   - Development environment
   - Custom configuration

3. **Component Selection**
   - Core TAK components
   - Optional plugins and extensions
   - Database configuration
   - Web interface options

4. **Network Configuration**
   - ZeroTier network setup
   - Tailscale integration
   - Static IP assignment
   - Port configuration

5. **Security Configuration**
   - Certificate authority setup
   - User authentication methods
   - Encryption settings
   - Access control policies

### 3. Installation Process

Automated installation workflow:
1. **Dependency Installation**
   - Check for required packages
   - Install missing dependencies
   - Configure package repositories

2. **Component Installation**
   - Download TAK packages
   - Extract and install components
   - Set file permissions
   - Create service accounts

3. **Configuration Generation**
   - Generate configuration files from templates
   - Customize settings based on user input
   - Validate configuration parameters
   - Set secure file permissions

4. **Service Configuration**
   - Create system service files
   - Configure auto-start settings
   - Set up log rotation
   - Configure monitoring

### 4. Post-Installation Setup

Final configuration steps:
1. **Database Initialization**
   - Create database schema
   - Set up initial user accounts
   - Configure database permissions
   - Test database connectivity

2. **Certificate Management**
   - Initialize certificate authority
   - Generate server certificates
   - Configure certificate trust
   - Set up certificate renewal

3. **Network Services**
   - Start TAK services
   - Configure firewall rules
   - Test network connectivity
   - Verify service availability

4. **User Setup**
   - Create administrator accounts
   - Configure user groups
   - Set up initial permissions
   - Generate client certificates

## Configuration Options

### System Configuration

```python
{
    "system": {
        "installation_type": "server|client|development",
        "install_directory": "/opt/tak",
        "data_directory": "/var/lib/tak",
        "log_directory": "/var/log/tak",
        "user": "takuser",
        "group": "takgroup"
    }
}
```

### Network Configuration

```python
{
    "network": {
        "bind_address": "0.0.0.0",
        "external_address": "tak.example.com",
        "ports": {
            "http": 8080,
            "https": 8443,
            "cot_tcp": 8087,
            "cot_udp": 8088,
            "cot_ssl": 8089
        },
        "zerotier": {
            "enabled": true,
            "network_id": "1234567890abcdef",
            "join_automatically": true
        },
        "tailscale": {
            "enabled": false,
            "auth_key": "tskey-xxxxxxxx"
        }
    }
}
```

### Security Configuration

```python
{
    "security": {
        "ssl": {
            "enabled": true,
            "keystore": "/opt/tak/certs/server.keystore",
            "keystore_password": "keystore_password",
            "truststore": "/opt/tak/certs/truststore.jks",
            "truststore_password": "truststore_password"
        },
        "authentication": {
            "methods": ["certificate", "username-password"],
            "ldap": {
                "enabled": false,
                "url": "ldap://ldap.example.com:389",
                "base_dn": "dc=example,dc=com"
            }
        },
        "certificates": {
            "ca": {
                "country": "US",
                "state": "California",
                "organization": "TAK Organization",
                "organizational_unit": "TAK CA"
            }
        }
    }
}
```

### Database Configuration

```python
{
    "database": {
        "type": "postgresql",
        "host": "localhost",
        "port": 5432,
        "name": "takdb",
        "username": "takuser",
        "password": "takpass",
        "connection_pool": {
            "min_size": 5,
            "max_size": 20
        }
    }
}
```

## Advanced Features

### Custom Templates

Support for custom configuration templates:
```python
# Custom template directory
template_directory = "/opt/tak/templates"

# Template variables
template_vars = {
    "server_name": "tak-server",
    "domain": "example.com",
    "admin_email": "admin@example.com"
}
```

### Plugin Management

Plugin installation and configuration:
```python
{
    "plugins": [
        {
            "name": "mission-planning",
            "enabled": true,
            "version": "1.2.3",
            "config": {
                "max_missions": 100,
                "storage_location": "/var/lib/tak/missions"
            }
        },
        {
            "name": "video-streaming",
            "enabled": false,
            "version": "2.1.0"
        }
    ]
}
```

### Service Monitoring

Built-in service monitoring:
```python
{
    "monitoring": {
        "health_checks": {
            "interval": 60,
            "timeout": 30,
            "endpoints": [
                "http://localhost:8080/health",
                "https://localhost:8443/status"
            ]
        },
        "alerts": {
            "email": {
                "enabled": true,
                "smtp_server": "smtp.example.com",
                "recipient": "admin@example.com"
            },
            "webhook": {
                "enabled": false,
                "url": "https://hooks.example.com/tak-alerts"
            }
        }
    }
}
```

## Error Handling

### Exception Management

Comprehensive error handling:
- Detailed error messages with context
- Automatic rollback on failure
- Logging of all operations
- Recovery options for partial failures

### Validation

Input and configuration validation:
- Format validation for IP addresses, ports, etc.
- Dependency checking before installation
- Configuration consistency verification
- Resource availability validation

### Recovery

Automatic recovery mechanisms:
- Configuration backup before changes
- Rollback capability for failed operations
- Manual recovery options
- Detailed error logs for troubleshooting

## Logging and Monitoring

### Log Levels

Configurable logging levels:
- DEBUG: Detailed diagnostic information
- INFO: General operational information
- WARNING: Warning conditions
- ERROR: Error conditions
- CRITICAL: Critical error conditions

### Log Format

Structured log output:
```
[2026-07-08 15:30:45] [INFO] Starting TAK server installation
[2026-07-08 15:30:46] [DEBUG] Detected Ubuntu 20.04 system
[2026-07-08 15:30:47] [INFO] Installing dependencies: java-11, postgresql
[2026-07-08 15:31:15] [INFO] Dependencies installed successfully
```

### Audit Trail

Comprehensive audit logging:
- All configuration changes
- Installation steps and timestamps
- User actions and decisions
- System modifications

## Integration with Other Tools

### ZeroTier Integration

Automatic ZeroTier setup:
- Network join automation
- Member authorization
- IP address management
- Connection monitoring

### Tailscale Integration

Tailscale configuration:
- Authentication key management
- Exit node configuration
- SSH access setup
- Network policy enforcement

### Docker Integration

Containerized deployment:
- Docker image management
- Container orchestration
- Volume mounting configuration
- Network configuration

## Customization

### Configuration Files

Support for external configuration:
```json
{
    "installation": {
        "type": "server",
        "components": ["core", "web", "database"],
        "network": {
            "ports": {
                "http": 8080,
                "https": 8443
            }
        }
    }
}
```

### Command Line Parameters

Extensive command line options:
```bash
# Configuration file
--config /path/to/config.json

# Non-interactive mode
--non-interactive

# Verbose output
--verbose

# Specific components
--components core,web,database

# Installation directory
--install-dir /custom/tak/path
```

### Template Customization

Custom template support:
- User-defined configuration templates
- Variable substitution
- Conditional configuration blocks
- Template validation

## Troubleshooting

### Common Issues

#### Installation Failures

If installation fails:
1. Check system requirements
2. Verify network connectivity
3. Review error logs for specific issues
4. Test with minimal configuration
5. Check disk space and permissions

#### Configuration Problems

If configuration fails:
1. Validate configuration file syntax
2. Check parameter values and formats
3. Verify file permissions
4. Test with sample configurations
5. Review validation error messages

#### Network Issues

If network problems occur:
1. Check firewall rules
2. Verify port availability
3. Test connectivity to required services
4. Review network interface configuration
5. Check ZeroTier/Tailscale status

### Diagnostic Tools

Built-in diagnostic capabilities:
```bash
# Validate configuration
python3 tak_setup.py --validate-only

# Check system requirements
python3 tak_setup.py --check-requirements

# Test network connectivity
python3 tak_setup.py --test-network

# Verify installation
python3 tak_setup.py --verify-installation
```

## Best Practices

### Installation

1. Always backup existing configurations
2. Test in non-production environments first
3. Document all configuration changes
4. Verify system requirements before installation
5. Use version-controlled configuration files

### Configuration

1. Use secure passwords and certificates
2. Implement least-privilege access controls
3. Regularly review and update configurations
4. Monitor system performance and resource usage
5. Maintain audit logs of all changes

### Security

1. Enable encryption for all communications
2. Use certificate-based authentication
3. Regularly update certificates and keys
4. Implement network segmentation
5. Monitor for security events and anomalies

### Maintenance

1. Regularly backup configuration and data
2. Keep software updated with security patches
3. Monitor system health and performance
4. Review and rotate certificates regularly
5. Test disaster recovery procedures

## Verification

### Installation Verification

Verify successful installation:
```bash
# Check TAK service status
systemctl status tak-server

# Verify listening ports
netstat -tlnp | grep java

# Test web interface
curl -I http://localhost:8080
```

### Configuration Validation

Validate configuration files:
```bash
# Check configuration syntax
python3 tak_setup.py --validate-config

# Verify certificate validity
openssl x509 -in /opt/tak/certs/server.crt -text -noout

# Test database connectivity
psql -U takuser -d takdb -c "SELECT version();"
```

### Network Verification

Verify network configuration:
```bash
# Check ZeroTier status
zerotier-cli listnetworks

# Test Tailscale connectivity
tailscale status

# Verify firewall rules
sudo ufw status
```