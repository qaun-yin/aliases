# TAK Docker Configuration Documentation

## Overview

This document provides guidance on configuring and running Team Awareness Kit (TAK) components using Docker containers. Docker enables consistent, isolated deployments of TAK server and client components across different environments.

## Features

- Containerized TAK deployments
- Consistent environments across systems
- Simplified installation and configuration
- Isolated service management
- Easy scaling and replication

## Docker Benefits for TAK

### Environment Consistency

Docker ensures that TAK runs identically across different systems:
- Eliminates "works on my machine" issues
- Standardizes dependencies and configurations
- Simplifies deployment across multiple servers

### Isolation

Containerization provides process and file system isolation:
- TAK services run in their own environment
- No conflicts with host system packages
- Secure separation between services

### Portability

Docker containers can be easily moved between environments:
- Development to production deployments
- Cloud to on-premises migrations
- Backup and disaster recovery

## TAK Server Docker Setup

### Prerequisites

- Docker installed on the host system
- Sufficient system resources (4GB+ RAM recommended)
- Network access for container communication
- Persistent storage for data retention

### Base Image Selection

Choose an appropriate base image:
```dockerfile
# Ubuntu-based image for full compatibility
FROM ubuntu:20.04

# Or CentOS for enterprise environments
FROM centos:7
```

### Container Configuration

#### Volume Mounts

Mount persistent storage for configuration and data:
```bash
# Configuration directory
-v /host/tak-config:/opt/tak/config

# Data directory
-v /host/tak-data:/opt/tak/data

# Logs directory
-v /host/tak-logs:/opt/tak/logs
```

#### Port Mapping

Expose necessary TAK ports:
```bash
# TAK server ports
-p 8080:8080    # Web interface
-p 8443:8443    # Secure web interface
-p 8087:8087    # TCP CoT
-p 8088:8088    # UDP CoT
```

#### Environment Variables

Configure TAK settings through environment variables:
```bash
# Server configuration
-e TAK_SERVER_PORT=8087
-e TAK_WEB_PORT=8080
-e TAK_SSL_PORT=8443

# Database settings
-e DB_HOST=localhost
-e DB_PORT=5432
-e DB_NAME=takdb
```

### Docker Compose Setup

Create a `docker-compose.yml` for simplified management:

```yaml
version: '3.8'

services:
  tak-server:
    image: tak-server:latest
    container_name: tak-server
    ports:
      - "8080:8080"
      - "8443:8443"
      - "8087:8087"
      - "8088:8088"
    volumes:
      - ./config:/opt/tak/config
      - ./data:/opt/tak/data
      - ./logs:/opt/tak/logs
    environment:
      - TAK_SERVER_PORT=8087
      - TAK_WEB_PORT=8080
    restart: unless-stopped

  tak-database:
    image: postgres:13
    container_name: tak-database
    environment:
      - POSTGRES_DB=takdb
      - POSTGRES_USER=takuser
      - POSTGRES_PASSWORD=takpass
    volumes:
      - ./db-data:/var/lib/postgresql/data
    restart: unless-stopped
```

## TAK Client Docker Setup

### Client Containerization

Containerize TAK clients for consistent deployment:
```dockerfile
FROM ubuntu:20.04

# Install TAK client dependencies
RUN apt-get update && apt-get install -y \
    tak-client \
    openjdk-11-jre \
    && rm -rf /var/lib/apt/lists/*

# Copy client configuration
COPY tak-client-config.xml /opt/tak/config/

# Set entrypoint
ENTRYPOINT ["/opt/tak/bin/tak-client"]
```

### Client Configuration

Mount client-specific configuration:
```bash
# Client configuration
-v /host/client-config:/opt/tak/config

# User data
-v /host/client-data:/opt/tak/data
```

## Security Considerations

### Container Security

Implement container security best practices:
- Use minimal base images
- Run containers as non-root users
- Regularly update base images
- Scan images for vulnerabilities

### Network Security

Secure TAK container networking:
```bash
# Use custom networks
docker network create tak-network

# Connect containers to secure network
docker run --network tak-network tak-server
```

### Data Security

Protect sensitive TAK data:
- Encrypt data volumes
- Use secrets management for credentials
- Implement backup and recovery procedures
- Regularly audit access logs

## Performance Optimization

### Resource Allocation

Configure container resources appropriately:
```bash
# CPU limits
--cpus="2.0"

# Memory limits
-m 4g

# Storage I/O limits
--storage-opt size=20G
```

### Container Monitoring

Monitor container performance:
```bash
# View container resource usage
docker stats tak-server

# Check container logs
docker logs -f tak-server

# Monitor system resources
docker exec tak-server top
```

## Backup and Recovery

### Configuration Backup

Backup TAK configuration regularly:
```bash
# Backup configuration directory
docker exec tak-server tar -czf /backup/config-$(date +%Y%m%d).tar.gz /opt/tak/config

# Copy backup to host
docker cp tak-server:/backup/config-$(date +%Y%m%d).tar.gz /host/backups/
```

### Data Backup

Backup TAK data and databases:
```bash
# Database backup
docker exec tak-database pg_dump -U takuser takdb > /host/backups/takdb-$(date +%Y%m%d).sql

# Data directory backup
docker exec tak-server tar -czf /backup/data-$(date +%Y%m%d).tar.gz /opt/tak/data
```

## Troubleshooting

### Container Startup Issues

If containers fail to start:
```bash
# Check container logs
docker logs tak-server

# Inspect container configuration
docker inspect tak-server

# Check system resources
docker info
```

### Network Connectivity

If network issues occur:
```bash
# Check port exposure
docker port tak-server

# Test container connectivity
docker exec tak-server netstat -tlnp

# Verify network configuration
docker network ls
```

### Performance Problems

If performance issues arise:
```bash
# Monitor resource usage
docker stats

# Check container processes
docker top tak-server

# Analyze logs for errors
docker logs --tail 100 tak-server
```

## Best Practices

### Image Management

1. Use specific image tags instead of latest
2. Regularly update and rebuild images
3. Scan images for security vulnerabilities
4. Minimize image size with multi-stage builds

### Container Orchestration

1. Use Docker Compose for multi-container setups
2. Implement health checks for automatic recovery
3. Use restart policies for service availability
4. Monitor container health and performance

### Configuration Management

1. Externalize configuration with environment variables
2. Use configuration management tools
3. Implement version control for configurations
4. Document all configuration changes

## Verification

### Container Status

Verify container operation:
```bash
# Check running containers
docker ps

# Verify TAK server is listening
docker exec tak-server netstat -tlnp | grep 8087

# Test web interface access
curl -I http://localhost:8080
```

### Service Functionality

Verify TAK services are functional:
```bash
# Check TAK server status
docker exec tak-server /opt/tak/bin/tak-server-status

# Verify database connectivity
docker exec tak-server /opt/tak/bin/tak-db-check

# Test client connectivity
docker exec tak-client /opt/tak/bin/tak-client-test
```