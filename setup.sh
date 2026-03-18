#!/bin/bash

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Ubuntu
check_system() {
    log_info "Checking system compatibility..."
    if [ ! -f /etc/os-release ]; then
        log_error "Cannot detect OS. This script is designed for Ubuntu."
        exit 1
    fi

    . /etc/os-release
    if [[ "$ID" != "ubuntu" ]]; then
        log_warning "This script is optimized for Ubuntu. Detected: $ID"
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    log_success "System check passed: Ubuntu $VERSION_ID"
}


# Deploy dotfiles
deploy_dotfiles() {
    log_info "Deploying dotfiles..."

    local dotfiles_dir="$SCRIPT_DIR/dotfiles"
    local backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

    # Skip bashrc to avoid overwriting user's shell configuration
    for file in tmux.conf vimrc; do
        local target="$HOME/.$file"
        local source="$dotfiles_dir/$file"

        if [ -f "$target" ] || [ -L "$target" ]; then
            log_warning "Existing $file found, backing up to $backup_dir"
            mkdir -p "$backup_dir"
            mv "$target" "$backup_dir/"
        fi

        ln -sf "$source" "$target"
        log_success "Linked .$file"
    done

    log_info "Skipped .bashrc (to preserve your shell configuration)"
    log_success "Dotfiles deployed successfully"
}

# Main execution
main() {
    echo -e "${BLUE}"
    echo "========================================="
    echo "  Server Bootstrap Setup"
    echo "========================================="
    echo -e "${NC}"

    check_system

    # Run installation scripts
    log_info "Starting installation process..."

    # Install basic tools
    if [ -f "$SCRIPT_DIR/scripts/install-basics.sh" ]; then
        log_info "Installing basic tools..."
        bash "$SCRIPT_DIR/scripts/install-basics.sh"
    else
        log_warning "install-basics.sh not found, skipping"
    fi

    # Deploy dotfiles
    deploy_dotfiles

    echo -e "\n${GREEN}"
    echo "========================================="
    echo "  Setup Complete!"
    echo "========================================="
    echo -e "${NC}"
    log_info "You can now install additional tools:"
    log_info "  - Claude Code: https://docs.anthropic.com/en/docs/claude-code"
    log_info "  - Codex: https://github.com/anthropics/codex"
    log_info ""
    log_info "Please restart your terminal or run: source ~/.bashrc"
}

main "$@"
