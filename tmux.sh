#!/bin/sh

# Source common utilities
. ./common.sh

detect_os

echo "Installing tmux dotfiles using $STOW_CMD..."
stow_package tmux

# Install TPM (Tmux Plugin Manager) if not already present
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install tmux plugins
if command -v tmux >/dev/null 2>&1; then
    echo "Installing tmux plugins..."
    # Start a server but don't attach to it
    tmux start-server
    # create a new session but don't attach to it either
    tmux new-session -d
    # install the plugins
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
    # killing the server is not required, I guess
    tmux kill-server
else
    echo "Warning: tmux not found, skipping plugin installation"
fi
