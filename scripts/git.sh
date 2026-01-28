#!/bin/bash
set -e

# scripts/git.sh

if [ -z "$COMMON_SOURCED" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/common.sh"
    COMMON_SOURCED=true
fi

install_git() {
    log_info "Installing Git..."

    # Git is often installed by common.sh as a dep, but we ensure latest/specific here if needed
    # For Ubuntu, apt install git is usually sufficient.
    # To get the absolute latest we might add ppa:git-core/ppa, but standard is usually fine for bootstrap.
    
    apt-get install -y git

    log_info "Git installed successfully."
    git --version
}

install_git
