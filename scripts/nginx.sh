#!/bin/bash
set -e

# scripts/nginx.sh

if [ -z "$COMMON_SOURCED" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/common.sh"
    COMMON_SOURCED=true
fi

install_nginx() {
    log_info "Installing Nginx..."

    apt-get install -y nginx

    # Basic configuration adjustment usually not needed for install, but we ensure it's running
    systemctl enable nginx
    systemctl start nginx

    log_info "Nginx installed and started successfully."
    nginx -v
}

install_nginx
