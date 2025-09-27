#!/bin/sh

# Common utilities for dotfiles installation
# Source this file in other scripts with: . ./common.sh

# Detect OS and set environment variables (only if not already set)
detect_os() {
    if [ -n "$OS" ] && [ -n "$STOW_CMD" ]; then
        return 0  # Already detected
    fi

    case "$(uname -s)" in
        Darwin*)
            OS="macOS"
            STOW_CMD="stow"
            ZSH_PATH="/opt/homebrew/bin/zsh"
            ;;
        Linux*)
            OS="Linux"
            STOW_CMD="xstow"
            ZSH_PATH="/usr/bin/zsh"
            ;;
        *)
            echo "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac

    export OS
    export STOW_CMD
    export ZSH_PATH
}

# Wrapper function for stow/xstow with correct syntax
stow_package() {
    local package="$1"
    local target="${2:-$HOME}"

    if [ -z "$package" ]; then
        echo "Error: package name required"
        return 1
    fi

    detect_os

    case "$STOW_CMD" in
        "stow")
            # GNU Stow syntax: stow -t TARGET PACKAGE
            stow -t "$target" "$package"
            ;;
        "xstow")
            # XStow syntax: xstow -t TARGET PACKAGE
            xstow -t "$target" "$package"
            ;;
        *)
            echo "Error: Unknown stow command: $STOW_CMD"
            return 1
            ;;
    esac
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install package manager dependencies based on OS
install_os_dependencies() {
    detect_os

    case "$OS" in
        "macOS")
            echo "Installing dependencies for macOS..."
            if ! command_exists brew; then
                echo "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install zsh curl neovim tmux git stow
            ;;
        "Linux")
            echo "Installing dependencies for Linux..."
            if [ -f "./ubuntu.sh" ]; then
                ./ubuntu.sh
            else
                echo "Warning: ubuntu.sh not found, please install dependencies manually"
            fi
            ;;
    esac
}