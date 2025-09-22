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

echo "Installing git dotfiles using $STOW_CMD..."
$STOW_CMD git -t ~

# Can't link to a git directory.
if [ -d "dotgit" ]; then
    echo "Linking dotgit directory..."
    ln -sf "$(pwd)/dotgit" ~/.git
fi
