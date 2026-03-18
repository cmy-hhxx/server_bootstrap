#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

# Install Clash Verge Rev
install_clash() {
    log_info "Installing Clash Verge Rev..."

    local deb_file="$SCRIPT_DIR/bin/clash-verge_2.4.6_amd64.deb"

    if [ ! -f "$deb_file" ]; then
        log_error "Clash installer not found: $deb_file"
        exit 1
    fi

    # Install the package
    sudo dpkg -i "$deb_file" || true

    # Fix dependencies if needed
    sudo apt-get install -f -y

    log_success "Clash Verge Rev installed"
}

# Configure Clash
configure_clash() {
    log_info "Configuring Clash..."

    local config_dir="$HOME/.config/clash-verge"
    mkdir -p "$config_dir"

    # Download subscription if provided
    if [ -n "$CLASH_SUBSCRIPTION_URL" ]; then
        log_info "Downloading Clash configuration from subscription..."

        if curl -fsSL "$CLASH_SUBSCRIPTION_URL" -o "$config_dir/config.yaml"; then
            log_success "Clash configuration downloaded"
        else
            log_error "Failed to download Clash configuration"
            log_info "Please configure Clash manually:"
            log_info "  1. Open Clash Verge Rev application"
            log_info "  2. Add your subscription URL in the settings"
            log_info "  3. Select a proxy node"
            return 1
        fi
    else
        log_warning "No subscription URL provided"
        log_info "Please configure Clash manually after installation"
        return 1
    fi
}

# Start Clash service
start_clash() {
    log_info "Starting Clash Verge Rev..."

    # Try to start the application
    if command -v clash-verge &>/dev/null; then
        nohup clash-verge &>/dev/null &
        log_success "Clash Verge Rev started"
    else
        log_warning "clash-verge command not found"
        log_info "Please start Clash Verge Rev manually from applications menu"
        return 1
    fi

    # Wait for service to start
    log_info "Waiting for proxy service to start..."
    sleep 5
}

# Configure proxy environment variables
configure_proxy_env() {
    log_info "Configuring proxy environment variables..."

    local proxy_url="http://127.0.0.1:${PROXY_PORT:-7890}"

    # Add to bashrc if not already present
    if ! grep -q "# Clash proxy settings" "$HOME/.bashrc"; then
        cat >> "$HOME/.bashrc" <<EOF

# Clash proxy settings
export http_proxy="$proxy_url"
export https_proxy="$proxy_url"
export all_proxy="socks5://127.0.0.1:${PROXY_PORT:-7890}"
export no_proxy="localhost,127.0.0.1,::1"
EOF
        log_success "Proxy environment variables added to ~/.bashrc"
    else
        log_info "Proxy settings already in ~/.bashrc"
    fi

    # Set for current session
    export http_proxy="$proxy_url"
    export https_proxy="$proxy_url"
    export all_proxy="socks5://127.0.0.1:${PROXY_PORT:-7890}"
}

# Test proxy connection
test_proxy() {
    log_info "Testing proxy connection..."

    local test_url="https://www.google.com"
    local max_attempts=3
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        log_info "Attempt $attempt/$max_attempts..."

        if curl -I --connect-timeout 10 "$test_url" &>/dev/null; then
            log_success "Proxy is working! Successfully connected to $test_url"
            return 0
        fi

        attempt=$((attempt + 1))
        if [ $attempt -le $max_attempts ]; then
            log_warning "Connection failed, retrying in 5 seconds..."
            sleep 5
        fi
    done

    log_error "Proxy test failed after $max_attempts attempts"
    log_info "Please check:"
    log_info "  1. Clash Verge Rev is running"
    log_info "  2. A proxy node is selected"
    log_info "  3. The proxy port is correct (default: 7890)"
    return 1
}

# Main
main() {
    log_info "Starting Clash installation..."

    install_clash

    if configure_clash; then
        start_clash
        configure_proxy_env
        test_proxy
    else
        log_warning "Clash installed but not configured"
        log_info "You can configure it manually later"
    fi

    log_success "Clash installation complete"
}

main "$@"