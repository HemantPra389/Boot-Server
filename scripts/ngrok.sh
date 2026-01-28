#!/bin/bash
set -e

# scripts/ngrok.sh

if [ -z "$COMMON_SOURCED" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/common.sh"
    COMMON_SOURCED=true
fi

install_ngrok() {
    log_info "Installing Ngrok..."

    # Create keyrings directory if it doesn't exist
    mkdir -p /etc/apt/keyrings

    # Add Ngrok GPG key
    curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
        | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null

    # Add Ngrok repository
    echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" \
        | tee /etc/apt/sources.list.d/ngrok.list

    # Update and install
    apt-get update -y
    apt-get install -y ngrok

    log_info "Ngrok installed successfully."
    ngrok --version
}

install_ngrok
