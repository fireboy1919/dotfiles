#!/bin/sh

# Use STOW_CMD if set by install-all.sh, otherwise detect OS
if [ -z "$STOW_CMD" ]; then
    case "$(uname -s)" in
        Darwin*)
            STOW_CMD="stow"
            ;;
        Linux*)
            STOW_CMD="xstow"
            ;;
        *)
            echo "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
fi

# Install universal-ctags for Vista plugin support
case "$(uname -s)" in
    Darwin*)
        if command -v brew >/dev/null 2>&1; then
            echo "Installing universal-ctags for Vista plugin..."
            brew install universal-ctags
        else
            echo "Warning: Homebrew not found. Please install universal-ctags manually for Vista plugin support."
        fi
        ;;
    Linux*)
        if command -v apt-get >/dev/null 2>&1; then
            echo "Installing universal-ctags for Vista plugin..."
            sudo apt-get update && sudo apt-get install -y universal-ctags
        elif command -v dnf >/dev/null 2>&1; then
            echo "Installing universal-ctags for Vista plugin..."
            sudo dnf install -y ctags
        else
            echo "Warning: Package manager not found. Please install universal-ctags manually for Vista plugin support."
        fi
        ;;
esac

echo "Installing nvim dotfiles using $STOW_CMD..."
$STOW_CMD nvim -t ~
