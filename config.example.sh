#!/bin/bash

# ============================================
# Server Bootstrap Configuration Template
# ============================================
# Copy this file to config.sh and fill in your values:
#   cp config.example.sh config.sh
#   vim config.sh

# --------------------------------------------
# Clash Proxy Configuration
# --------------------------------------------
# Your Clash subscription URL (required for auto-configuration)
CLASH_SUBSCRIPTION_URL=""

# Local proxy port (default: 7890)
PROXY_PORT=7890

# --------------------------------------------
# Installation Options
# --------------------------------------------
# Install Clash Verge Rev proxy client
INSTALL_CLASH=true

# --------------------------------------------
# Git Configuration (Optional)
# --------------------------------------------
# If provided, git will be configured with these values
GIT_USER_NAME=""
GIT_USER_EMAIL=""

# --------------------------------------------
# APT Mirror (Optional)
# --------------------------------------------
# Uncomment to use a specific mirror (aliyun, tsinghua, or default)
# APT_MIRROR="aliyun"
