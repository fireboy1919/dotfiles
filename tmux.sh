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

echo "Installing tmux dotfiles using $STOW_CMD..."
$STOW_CMD tmux -t ~

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
