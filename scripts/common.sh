#!/bin/bash
set -e

# common.sh
# Core system setup and common utilities

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper for logging
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

setup_common() {
    log_info "Running common system setup..."

    # Check for root is done in install.sh, but good to be safe if run standalone (though designed to be sourced or called)
    if [[ $EUID -ne 0 ]]; then
       log_error "This script must be run as root" 
       exit 1
    fi

    # Update package lists
    log_info "Updating apt package lists..."
    apt-get update -y

    # Install basic dependencies
    log_info "Installing basic dependencies..."
    apt-get install -y curl wget git software-properties-common ca-certificates gnupg lsb-release

    log_info "Common setup completed."
}
