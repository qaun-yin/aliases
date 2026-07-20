#!/bin/bash

# NGINX Setup Script
# Brief description of what the script does
#
# This script automates the installation and configuration of NGINX web server with SSL support.
# It configures virtual hosts, sets up SSL certificates, and integrates with ZeroTier networking.
# The script also provides options to install additional tools like Certbot, Docker, and ZeroTier.
#
# Requirements:
# - Ubuntu/Debian-based system
# - Root privileges (sudo)
# - Internet connectivity
# - ZeroTier network membership (optional)
#
# Usage:
# sudo ./nginx_setup.sh
#
# Examples:
# sudo ./nginx_setup.sh
#
# Features:
# - Automated NGINX installation
# - Virtual host configuration
# - SSL certificate setup
# - ZeroTier network integration
# - Optional tool installation (Certbot, Docker, ZeroTier)
# - DNS configuration guidance
#
# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as root. Please use sudo."
    exit 1
fi

# Function to prompt for domain details
is_valid_ipv4() {
    local ip=$1 octet
    [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || return 1
    IFS='.' read -r -a octets <<<"$ip"
    for octet in "${octets[@]}"; do
        ((octet >= 0 && octet <= 255)) || return 1
    done
}

restart_service() {
    local service=$1
    if command -v systemctl >/dev/null 2>&1; then
        systemctl restart "$service"
    elif command -v service >/dev/null 2>&1; then
        service "$service" restart
    elif [ -x "/etc/init.d/$service" ]; then
        "/etc/init.d/$service" restart
    else
        echo "ERROR: Could not restart $service; no supported service manager found."
        return 1
    fi
}

prompt_for_details() {
    echo "Let's set up NGINX for your server."
    read -p "Enter your main domain (e.g., example.com): " MAIN_DOMAIN
    read -p "Enter your sandbox domain (e.g., sandbox.example.com): " SANDBOX_DOMAIN
    read -p "Enter your ZeroTier IP (e.g., 10.6.4.2, leave blank for all interfaces): " ZEROTIER_IP

    if [ -n "$ZEROTIER_IP" ] && ! is_valid_ipv4 "$ZEROTIER_IP"; then
        echo "ERROR: Invalid ZeroTier IP: $ZEROTIER_IP"
        exit 1
    fi

    echo "Configuring NGINX with the following details:"
    echo "Main Domain: $MAIN_DOMAIN"
    echo "Sandbox Domain: $SANDBOX_DOMAIN"
    echo "ZeroTier IP: $ZEROTIER_IP"
    read -p "Are these details correct? (yes/no): " CONFIRM
    if [[ "$CONFIRM" != "yes" ]]; then
        echo "Exiting setup. Please re-run the script to correct the details."
        exit 1
    fi
}

# Function to install NGINX and dependencies
install_nginx() {
    echo "Installing NGINX and dependencies..."
    apt-get update -y
    apt-get install -y nginx
    echo "NGINX installed successfully."
}

# Function to create NGINX configuration
configure_nginx() {
    echo "Creating NGINX configuration files..."
    NGINX_CONF="/etc/nginx/sites-available/$MAIN_DOMAIN"
    if [ -n "$ZEROTIER_IP" ]; then
        LISTEN_DIRECTIVE="listen $ZEROTIER_IP:443 ssl http2;"
    else
        LISTEN_DIRECTIVE="listen 443 ssl http2;"
    fi
    cat >"$NGINX_CONF" <<EOF
server {
    $LISTEN_DIRECTIVE
    server_name $MAIN_DOMAIN $SANDBOX_DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$MAIN_DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$MAIN_DOMAIN/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    root /var/www/$MAIN_DOMAIN;
    index index.html;

    # Restrict to ZeroTier network
    allow 10.6.4.0/22;
    deny all;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /cryptpad_websocket {
        proxy_pass http://localhost:3003;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

    # Create symbolic link and test configuration
    ln -sfn "$NGINX_CONF" "/etc/nginx/sites-enabled/$MAIN_DOMAIN"
    nginx -t
    if [ $? -ne 0 ]; then
        echo "NGINX configuration test failed. Please check your configuration."
        exit 1
    fi

    # Restart NGINX
    restart_service nginx
    echo "NGINX configured and restarted successfully."
}

# Function to install additional tools
install_optional_tools() {
    echo "Optional tools available for installation:"
    echo "1) Certbot for Let's Encrypt SSL certificates"
    echo "2) Docker"
    echo "3) ZeroTier"
    echo "4) None"
    read -p "Enter the number corresponding to the tool you want to install: " OPTION

    case $OPTION in
    1)
        echo "Installing Certbot..."
        apt-get install -y certbot python3-certbot-nginx
        echo "Certbot installed. You can run 'certbot --nginx' to obtain SSL certificates."
        ;;
    2)
        echo "Installing Docker..."
        apt-get install -y docker.io
        systemctl enable docker
        systemctl start docker
        echo "Docker installed and started."
        ;;
    3)
        echo "Installing ZeroTier..."
        ZEROTIER_INSTALLER=$(mktemp)
        curl -fsSL https://install.zerotier.com -o "$ZEROTIER_INSTALLER"
        bash "$ZEROTIER_INSTALLER"
        rm -f "$ZEROTIER_INSTALLER"
        if command -v systemctl >/dev/null 2>&1; then
            systemctl enable zerotier-one
            systemctl start zerotier-one
        else
            restart_service zerotier-one
        fi
        echo "ZeroTier installed. Use 'zerotier-cli join <networkID>' to join a network."
        ;;
    4)
        echo "Skipping additional tool installation."
        ;;
    *)
        echo "Invalid option. Skipping additional tool installation."
        ;;
    esac
}

# Function to display DNS update instructions
dns_instructions() {
    echo "You need to update your DNS records as follows:"
    echo "1) Add an A record for your main domain:"
    echo "   Name: $MAIN_DOMAIN"
    echo "   Type: A"
    echo "   Value: Your ZeroTier IP ($ZEROTIER_IP)"
    echo "2) Add an A record for your sandbox domain:"
    echo "   Name: $SANDBOX_DOMAIN"
    echo "   Type: A"
    echo "   Value: Your ZeroTier IP ($ZEROTIER_IP)"
    echo "3) If you're using Cloudflare, ensure Proxy Status is set to 'DNS only'."
    echo "Once the DNS records propagate, your server will be accessible via the configured domains."
}

# Function to display dashboard access instructions
dashboard_instructions() {
    echo "Your NGINX setup is complete!"
    echo "You can access your server as follows:"
    echo "1) For the main domain, visit: https://$MAIN_DOMAIN"
    echo "2) For the sandbox domain, visit: https://$SANDBOX_DOMAIN"
    echo "Ensure you are connected to the ZeroTier network to access these links."
}

# Main function to orchestrate the setup
main() {
    echo "Starting NGINX setup..."
    prompt_for_details
    install_nginx
    configure_nginx
    install_optional_tools
    dns_instructions
    dashboard_instructions
    echo "Setup complete. Enjoy your configured server!"
}

# Run the main function
main
