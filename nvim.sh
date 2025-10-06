#!/bin/sh

# Source common utilities
. ./common.sh

detect_os

# Install universal-ctags for Vista plugin support
case "$OS" in
    "macOS")
        if command_exists brew; then
            echo "Installing universal-ctags for Vista plugin..."
            brew install universal-ctags
        else
            echo "Warning: Homebrew not found. Please install universal-ctags manually for Vista plugin support."
        fi
        ;;
    "Linux")
        if command_exists apt-get; then
            echo "Installing universal-ctags for Vista plugin..."
            sudo apt-get update && sudo apt-get install -y universal-ctags
        elif command_exists dnf; then
            echo "Installing universal-ctags for Vista plugin..."
            sudo dnf install -y ctags
        else
            echo "Warning: Package manager not found. Please install universal-ctags manually for Vista plugin support."
        fi
        ;;
esac

echo "Installing nvim dotfiles using $STOW_CMD..."
stow_package nvim
