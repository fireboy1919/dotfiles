#!/bin/sh

# Source common utilities
. ./common.sh

# Main installation
detect_os
echo "Detected OS: $OS, using $STOW_CMD"
install_os_dependencies

echo "Installing dotfiles..."
./tmux.sh
./nvim.sh
./git.sh
./zsh.sh

echo "Installation complete!"
