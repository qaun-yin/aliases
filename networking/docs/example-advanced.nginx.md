# Advanced NGINX Configuration Documentation

## Overview

This configuration file provides an example of an advanced NGINX setup with security enhancements, performance optimizations, and reverse proxy capabilities. It demonstrates best practices for securing web applications and optimizing content delivery.

## Features

- SSL/TLS configuration with strong security settings
- Security headers for XSS and clickjacking protection
- Rate limiting to prevent abuse
- Gzip compression for improved performance
- Custom error pages
- Reverse proxy configuration
- Access control and IP restrictions
- Logging and monitoring capabilities

## Configuration Sections

### 1. Server Block Definition

The configuration starts with defining the server block:
```nginx
server {
    listen 443 ssl http2;
    server_name example.com;
}
```

Key directives:
- `listen 443 ssl http2`: Listen on HTTPS port with HTTP/2 support
- `server_name`: Define the domain name for this server block

### 2. SSL/TLS Configuration

Security-focused SSL settings:
```nginx
ssl_certificate /path/to/certificate.crt;
ssl_certificate_key /path/to/private.key;
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;
ssl_prefer_server_ciphers off;
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;
```

Security features:
- Modern TLS protocols (TLS 1.2 and 1.3)
- Strong cipher suites
- Session caching for performance
- Perfect Forward Secrecy support

### 3. Security Headers

HTTP headers for enhanced security:
```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
```

Protection against:
- Clickjacking attacks (X-Frame-Options)
- Cross-site scripting (X-XSS-Protection)
- MIME type sniffing (X-Content-Type-Options)
- Information leakage (Referrer-Policy)
- Code injection (Content-Security-Policy)

### 4. Rate Limiting

DDoS and abuse prevention:
```nginx
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
limit_req zone=api burst=20 nodelay;
```

Features:
- IP-based rate limiting
- Configurable request rates
- Burst handling for legitimate traffic spikes

### 5. Gzip Compression

Performance optimization through compression:
```nginx
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_proxied expired no-cache no-store private must-revalidate auth;
gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss;
```

Benefits:
- Reduced bandwidth usage
- Faster page load times
- Configurable compression thresholds
- Support for various content types

### 6. Reverse Proxy Configuration

Application server integration:
```nginx
location / {
    proxy_pass http://backend;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

Features:
- Load balancing between backend servers
- Header preservation for application context
- Protocol handling (HTTP/HTTPS)
- Client IP address forwarding

### 7. Access Control

Security through IP restrictions:
```nginx
location /admin {
    allow 192.168.1.0/24;
    deny all;
}
```

Capabilities:
- Whitelist-based access control
- Network range restrictions
- Location-specific security rules

### 8. Custom Error Pages

User-friendly error handling:
```nginx
error_page 404 /custom_404.html;
error_page 500 502 503 504 /custom_50x.html;
```

Benefits:
- Branded error pages
- Consistent user experience
- Reduced information disclosure

### 9. Logging Configuration

Comprehensive monitoring and debugging:
```nginx
access_log /var/log/nginx/example.com.access.log;
error_log /var/log/nginx/example.com.error.log;
```

Features:
- Separate access and error logs
- Customizable log formats
- Per-server log files

## Usage

### Installation

1. Copy the configuration to NGINX sites-available:
   ```bash
   sudo cp example-advanced.nginx.conf /etc/nginx/sites-available/example.com
   ```

2. Create a symbolic link to sites-enabled:
   ```bash
   sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
   ```

3. Test the configuration:
   ```bash
   sudo nginx -t
   ```

4. Reload NGINX:
   ```bash
   sudo systemctl reload nginx
   ```

### Customization

#### SSL Certificates

Update certificate paths to match your installation:
```nginx
ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
```

#### Domain Names

Modify server_name to match your domain:
```nginx
server_name yourdomain.com www.yourdomain.com;
```

#### Backend Servers

Update proxy_pass to point to your application servers:
```nginx
upstream backend {
    server 127.0.0.1:3000;
    server 127.0.0.1:3001;
}
```

#### Rate Limiting

Adjust rate limiting based on your requirements:
```nginx
# For high-traffic sites
limit_req_zone $binary_remote_addr zone=api:50m rate=100r/s;

# For stricter security
limit_req_zone $binary_remote_addr zone=api:10m rate=1r/s;
```

## Security Considerations

### SSL/TLS Best Practices

- Use certificates from trusted Certificate Authorities
- Enable OCSP stapling for improved performance
- Regularly update cipher suites
- Monitor for SSL/TLS vulnerabilities

### Header Security

- Review Content Security Policy for your specific application
- Consider implementing HTTP Strict Transport Security (HSTS)
- Evaluate the need for additional security headers

### Access Control

- Regularly review IP whitelists
- Implement additional authentication for sensitive locations
- Consider integrating with authentication proxies

## Performance Optimization

### Caching Strategies

- Implement browser caching headers
- Configure reverse proxy caching
- Consider using a CDN for static assets

### Compression

- Optimize gzip compression levels
- Enable Brotli compression for modern browsers
- Configure compression for additional content types

### Load Balancing

- Implement health checks for backend servers
- Configure session persistence if needed
- Monitor backend server performance

## Troubleshooting

### Configuration Errors

Test configuration before reloading:
```bash
sudo nginx -t
```

Check error logs for specific issues:
```bash
sudo tail -f /var/log/nginx/error.log
```

### SSL Issues

Verify certificate installation:
```bash
openssl x509 -in /path/to/certificate.crt -text -noout
```

Check SSL handshake:
```bash
openssl s_client -connect example.com:443
```

### Performance Problems

Monitor access logs:
```bash
sudo tail -f /var/log/nginx/access.log
```

Analyze request patterns:
```bash
sudo awk '{print $9}' /var/log/nginx/access.log | sort | uniq -c | sort -rn
```

## Verification

### SSL Configuration

Test SSL security:
```bash
openssl s_client -connect example.com:443 -servername example.com
```

### Security Headers

Verify headers are sent:
```bash
curl -I https://example.com
```

### Rate Limiting

Test rate limiting with curl:
```bash
for i in {1..20}; do curl -s -w "%{http_code}\n" -o /dev/null https://example.com/api/endpoint; done
```

## Best Practices

1. **Regular Updates**: Keep NGINX updated with security patches
2. **Monitoring**: Implement log monitoring and alerting
3. **Backups**: Maintain backups of working configurations
4. **Testing**: Test configuration changes in staging first
5. **Documentation**: Document customizations for future reference
6. **Security Audits**: Regularly review security configurations