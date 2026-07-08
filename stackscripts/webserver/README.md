# Web Server StackScript

This StackScript automates the setup of a production-ready web server environment on Linode. It installs and configures a web server, SSL certificates, and security measures for hosting websites and applications.

## Overview

The web server StackScript creates a secure, optimized web server environment with:

- Web server installation (Nginx)
- SSL certificate configuration with Let's Encrypt
- Security hardening measures
- Performance optimization

## Features

### Web Server
- Nginx installation and configuration
- Virtual host setup
- Static file serving optimization
- Reverse proxy capabilities

### SSL Configuration
- Let's Encrypt certificate installation
- Automatic certificate renewal
- HTTPS enforcement
- Strong SSL cipher configuration

### Security
- SSH hardening
- Fail2ban installation and configuration
- Firewall configuration with UFW
- Security headers implementation

### Performance
- Gzip compression
- Browser caching headers
- Static asset optimization
- Log rotation setup

## Usage

To use this StackScript:

1. Create a Linode account
2. Navigate to the StackScripts section
3. Create a new StackScript using the provision.sh content
4. Deploy a new Linode using this StackScript

### Parameters

This StackScript accepts the following parameters:

- **domain**: The domain name for the web server
- **username**: The username for the primary user account
- **password**: The password for the primary user account
- **ssh_key**: Public SSH key for secure access
- **email**: Email address for Let's Encrypt notifications

## Configuration

### Nginx Setup

Installs and configures Nginx with security and performance optimizations:

```bash
# Install Nginx
apt-get install nginx

# Configure security headers
add_header X-Frame-Options "SAMEORIGIN"
add_header X-XSS-Protection "1; mode=block"
```

### SSL Certificate Installation

Automatically installs and configures Let's Encrypt SSL certificates:

```bash
# Install Certbot
apt-get install certbot python3-certbot-nginx

# Obtain and install certificate
certbot --nginx -d ${DOMAIN} --non-interactive --agree-tos --email ${EMAIL}
```

### Firewall Configuration

Sets up UFW with web server-specific rules:

```bash
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

### Performance Optimization

Configures Nginx for optimal performance:

```bash
# Enable gzip compression
gzip on;
gzip_vary on;
gzip_min_length 1024;

# Set cache headers for static assets
location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

## Examples

### Basic Deployment

1. Create a new Linode
2. Select this StackScript
3. Provide required parameters:
   - domain: example.com
   - username: webmaster
   - password: [secure password]
   - ssh_key: [your public key]
   - email: admin@example.com
4. Deploy the Linode

### Post-Deployment Access

After deployment, access your website:

```bash
# SSH access
ssh webmaster@your-linode-ip

# Website access
curl https://example.com
```

The web server will be ready to serve content with SSL encryption and security measures in place.

## Troubleshooting

### Common Issues

1. **SSL Certificate Installation Failures**
   - Verify domain DNS records
   - Check domain ownership
   - Confirm email address validity

2. **Nginx Configuration Errors**
   - Check configuration syntax with `nginx -t`
   - Review virtual host configuration
   - Verify file permissions

3. **Firewall Blocking Access**
   - Verify UFW rules
   - Check for conflicting firewall software
   - Confirm port availability

### Getting Help

If you encounter issues not covered in this documentation:

1. Check the Linode StackScript documentation
2. Review Nginx error logs in /var/log/nginx/
3. Check Let's Encrypt logs in /var/log/letsencrypt/
4. Open an issue on GitHub with detailed information
5. Include error messages and deployment parameters