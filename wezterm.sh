#!/bin/sh

# Source common utilities
. ./common.sh

detect_os

# Install wezterm if not already installed
if ! command_exists wezterm; then
    echo "Installing WezTerm..."
    case "$OS" in
        "macOS")
            brew install --cask wezterm
            ;;
        "Linux")
            # Add the wezterm apt repository
            curl -fsSL https://apt.fury.io/wez/gpg.key \
                | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
            echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' \
                | sudo tee /etc/apt/sources.list.d/wezterm.list
            sudo apt update && sudo apt install -y wezterm
            ;;
    esac
else
    echo "WezTerm already installed, skipping..."
fi

echo "Installing wezterm dotfiles using $STOW_CMD..."
stow_package wezterm
