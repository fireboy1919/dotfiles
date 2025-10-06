#!/bin/sh

# Source common utilities
. ./common.sh

detect_os

# Install lefthook on macOS
if [ "$OS" = "macOS" ] && command_exists brew; then
    echo "Installing lefthook..."
    brew install lefthook
fi

echo "Installing git dotfiles using $STOW_CMD..."
stow_package git

# Install opencommit globally
if command -v npm >/dev/null 2>&1; then
    if ! npm list -g opencommit >/dev/null 2>&1; then
        echo "Installing opencommit..."
        npm install -g opencommit
    fi
fi

# Configure opencommit with custom endpoint if airtool is available
if command -v oco >/dev/null 2>&1 && command -v airtool >/dev/null 2>&1; then
    echo "Configuring opencommit with Airbnb API URL..."
    oco config set OCO_API_URL='https://devaigateway.a.musta.ch' >/dev/null 2>&1 || true
fi

# Can't link to a git directory.
if [ -d "dotgit" ]; then
    echo "Linking dotgit directory..."
    ln -sf "$(pwd)/dotgit" ~/.git
fi
