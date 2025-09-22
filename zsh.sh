#!/bin/sh

# Use STOW_CMD if set by install-all.sh, otherwise detect OS
if [ -z "$STOW_CMD" ]; then
    case "$(uname -s)" in
        Darwin*)
            STOW_CMD="stow"
            ZSH_PATH="/opt/homebrew/bin/zsh"
            ;;
        Linux*)
            STOW_CMD="xstow"
            ZSH_PATH="/usr/bin/zsh"
            ;;
        *)
            echo "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
fi

# Set ZSH_PATH if not already set
if [ -z "$ZSH_PATH" ]; then
    case "$(uname -s)" in
        Darwin*)
            ZSH_PATH="/opt/homebrew/bin/zsh"
            ;;
        Linux*)
            ZSH_PATH="/usr/bin/zsh"
            ;;
    esac
fi

echo "Installing zsh dotfiles using $STOW_CMD..."
$STOW_CMD zsh -t ~

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
