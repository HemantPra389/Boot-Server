#!/bin/bash
set -e

# scripts/docker.sh

# Source common for logging context if not already available
if [ -z "$COMMON_SOURCED" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/common.sh"
    COMMON_SOURCED=true
fi

install_docker() {
    log_info "Installing Docker..."

    # Uninstall old versions
    apt-get remove -y docker docker-engine docker.io containerd runc || true

    # Add Docker's official GPG key
    mkdir -p /etc/apt/keyrings
    rm -f /etc/apt/keyrings/docker.gpg
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Set up the repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    log_info "Docker installed successfully."
    docker --version
}

install_docker
