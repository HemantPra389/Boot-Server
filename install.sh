#!/bin/bash
set -e

# install.sh
# Main entry point for the Server Bootstrap installer.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/common.sh"

# Default configuration file
CONFIG_FILE="setup.conf"
NON_INTERACTIVE=false
SKIP_ALL=false

# Package list (Display Name:Script Name)
declare -A PACKAGES
PACKAGES=( ["Docker"]="docker" ["NodeJS"]="node" ["Nginx"]="nginx" ["Git"]="git" )
# Order is important for asking, associative arrays are unordered in Bash 4, so we need a list
PACKAGE_ORDER=("Docker" "NodeJS" "Nginx" "Git")
declare -A INSTALL_CHOICES

usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --non-interactive  Run in non-interactive mode using defaults or config file."
    echo "  --config <file>    Specify config file (default: setup.conf)"
    echo "  --help             Show this help message"
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --non-interactive) NON_INTERACTIVE=true ;;
        --config) CONFIG_FILE="$2"; shift ;;
        --help) usage; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; usage; exit 1 ;;
    esac
    shift
done

main() {
    # Check for root permissions
    if [[ $EUID -ne 0 ]]; then
       log_error "This script must be run as root." 
       exit 1
    fi

    # Header
    echo -e "${GREEN}"
    echo "============================================"
    echo "   Server Bootstrap Installer"
    echo "============================================"
    echo -e "${NC}"

    # Run common setup
    setup_common

    if [ "$NON_INTERACTIVE" = true ]; then
        run_non_interactive
    else
        run_interactive
    fi

    # Execute installations based on choices
    process_installations

    log_info "Server bootstrap completed successfully!"
}

run_non_interactive() {
    log_info "Running in non-interactive mode."
    if [ -f "$CONFIG_FILE" ]; then
        log_info "Loading configuration from $CONFIG_FILE"
        source "$CONFIG_FILE"
        # Map config vars to choices
        # Expect config vars like INSTALL_DOCKER=true/false
        INSTALL_CHOICES["Docker"]=${INSTALL_DOCKER:-false}
        INSTALL_CHOICES["NodeJS"]=${INSTALL_NODE:-false}
        INSTALL_CHOICES["Nginx"]=${INSTALL_NGINX:-false}
        INSTALL_CHOICES["Git"]=${INSTALL_GIT:-false}
    else
        log_warn "Config file not found at $CONFIG_FILE. No packages will be installed by default."
    fi
}

get_user_input() {
    local pkg_name=$1
    local prompt_msg="$pkg_name   [Y]es [N]o [S]kip"
    local valid=false
    local choice=""

    while [ "$valid" = false ]; do
        read -p "$(echo -e "$prompt_msg: ")" choice
        choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
        
        case "$choice" in
            y|yes)
                INSTALL_CHOICES["$pkg_name"]="true"
                valid=true
                ;;
            n|no)
                INSTALL_CHOICES["$pkg_name"]="false"
                valid=true
                ;;
            s|skip)
                INSTALL_CHOICES["$pkg_name"]="skip"
                valid=true
                handle_skip
                ;;
            *)
                echo "Invalid input. Please enter Yes, No, or Skip."
                ;;
        esac
    done
}

handle_skip() {
    if [ "$SKIP_ALL" = false ]; then
        local choice=""
        local valid=false
        while [ "$valid" = false ]; do
            read -p "Skip all remaining packages? [Y]es [N]o: " choice
            choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
            case "$choice" in
                y|yes)
                    SKIP_ALL=true
                    valid=true
                    ;;
                n|no)
                    valid=true
                    ;;
                *)
                    echo "Invalid input. Please enter Yes or No."
                    ;;
            esac
        done
    fi
}

run_interactive() {
    echo ""
    log_info "Starting interactive package selection..."

    for pkg in "${PACKAGE_ORDER[@]}"; do
        if [ "$SKIP_ALL" = true ]; then
            log_info "Skipping $pkg (Skip All detected)"
            INSTALL_CHOICES["$pkg"]="false" # Treat skipped as false for installation
        else
            get_user_input "$pkg"
        fi
    done
}

process_installations() {
    echo ""
    log_info "Processing installations..."

    for pkg in "${PACKAGE_ORDER[@]}"; do
        script_name=${PACKAGES[$pkg]}
        should_install=${INSTALL_CHOICES[$pkg]}

        if [ "$should_install" == "true" ]; then
            log_info "Installing $pkg..."
            # Execute the script
            bash "$SCRIPT_DIR/scripts/$script_name.sh"
        elif [ "$should_install" == "skip" ]; then
             log_info "Skipped $pkg."
        else
             log_info "Not installing $pkg."
        fi
    done
}

main
