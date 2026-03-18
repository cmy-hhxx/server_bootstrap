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

# Configure APT mirror
configure_apt_mirror() {
    if [ -n "$APT_MIRROR" ]; then
        log_info "Configuring APT mirror: $APT_MIRROR"

        local mirror_url
        case "$APT_MIRROR" in
            aliyun)
                mirror_url="http://mirrors.aliyun.com/ubuntu/"
                ;;
            tsinghua)
                mirror_url="https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
                ;;
            *)
                log_warning "Unknown mirror: $APT_MIRROR, using default"
                return
                ;;
        esac

        # Backup original sources.list
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

        # Get Ubuntu codename
        local codename=$(lsb_release -cs)

        # Create new sources.list
        sudo tee /etc/apt/sources.list > /dev/null <<EOF
deb $mirror_url $codename main restricted universe multiverse
deb $mirror_url $codename-updates main restricted universe multiverse
deb $mirror_url $codename-backports main restricted universe multiverse
deb $mirror_url $codename-security main restricted universe multiverse
EOF

        log_success "APT mirror configured"
    fi
}

# Update package list
update_apt() {
    log_info "Updating package list..."
    sudo apt-get update -y
    log_success "Package list updated"
}

# Install basic tools
install_basics() {
    log_info "Installing basic development tools..."

    local packages=(
        git
        curl
        wget
        vim
        tmux
        build-essential
        jq
        ca-certificates
        gnupg
        lsb-release
    )

    sudo apt-get install -y "${packages[@]}"
    log_success "Basic tools installed"
}

# Install ripgrep
install_ripgrep() {
    log_info "Installing ripgrep..."

    # Try apt first
    if apt-cache show ripgrep &>/dev/null; then
        sudo apt-get install -y ripgrep
        log_success "ripgrep installed from apt"
    else
        # Download from GitHub releases
        log_info "ripgrep not in apt, downloading from GitHub..."
        local version="15.1.0"
        local deb_file="ripgrep_${version}-1_amd64.deb"
        local download_url="https://github.com/BurntSushi/ripgrep/releases/download/${version}/${deb_file}"

        wget -q "$download_url" -O "/tmp/$deb_file"
        sudo dpkg -i "/tmp/$deb_file"
        rm "/tmp/$deb_file"
        log_success "ripgrep installed from GitHub"
    fi
}

# Configure git
configure_git() {
    if [ -n "$GIT_USER_NAME" ] && [ -n "$GIT_USER_EMAIL" ]; then
        log_info "Configuring git..."
        git config --global user.name "$GIT_USER_NAME"
        git config --global user.email "$GIT_USER_EMAIL"
        log_success "Git configured"
    else
        log_info "Git user info not provided, skipping git configuration"
    fi
}

# Main
main() {
    log_info "Starting basic tools installation..."

    configure_apt_mirror
    update_apt
    install_basics
    install_ripgrep
    configure_git

    log_success "Basic tools installation complete"
}

main "$@"