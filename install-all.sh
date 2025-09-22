#!/bin/sh

# Detect OS and set appropriate package manager and stow command
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            OS="macOS"
            STOW_CMD="stow"
            ;;
        Linux*)
            OS="Linux"
            STOW_CMD="xstow"
            ;;
        *)
            echo "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
    export OS
    export STOW_CMD
    echo "Detected OS: $OS, using $STOW_CMD"
}

# Install dependencies based on OS
install_dependencies() {
    case "$OS" in
        "macOS")
            echo "Installing dependencies for macOS..."
            # Check if Homebrew is installed
            if ! command -v brew >/dev/null 2>&1; then
                echo "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install zsh curl neovim tmux git stow
            ;;
        "Linux")
            echo "Installing dependencies for Linux..."
            ./ubuntu.sh
            ;;
    esac
}

# Main installation
detect_os
install_dependencies

echo "Installing dotfiles..."
./tmux.sh
./nvim.sh
./git.sh
./zsh.sh

echo "Installation complete!"
