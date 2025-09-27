#!/bin/sh

# Source common utilities
. ./common.sh

detect_os

echo "Installing zsh dotfiles using $STOW_CMD..."
stow_package zsh

# Change shell to zsh if it exists
if [ -f "$ZSH_PATH" ]; then
    echo "Changing shell to $ZSH_PATH"
    chsh -s "$ZSH_PATH"
else
    echo "Warning: zsh not found at $ZSH_PATH, trying /bin/zsh"
    if [ -f "/bin/zsh" ]; then
        chsh -s "/bin/zsh"
    else
        echo "Error: zsh not found, please install zsh first"
        exit 1
    fi
fi

# Install SDKMAN if available
if [ -f "./sdkman.sh" ]; then
    zsh -c ". ./sdkman.sh"
fi
