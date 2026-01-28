#!/bin/bash
set -e

# scripts/node.sh

if [ -z "$COMMON_SOURCED" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/common.sh"
    COMMON_SOURCED=true
fi

install_node() {
    log_info "Installing Node.js (LTS)..."

    # Using NodeSource for updated Node versions (Ubuntu default is often old)
    # Check if curl is available (should be from common)
    
    # Download and invoke the NodeSource setup script (for Node 20.x LTS)
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    
    apt-get install -y nodejs

    log_info "Node.js installed successfully."
    node -v
    npm -v
}

install_node
