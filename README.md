Rusty Phillips' dotfiles.  
Built in config for git, nvim, tmux, and zsh with cross-platform support for macOS and Linux.

## Installation

### Quick Install (Recommended)
Run `./install-all.sh` to automatically detect your OS and install everything:
- **macOS**: Uses Homebrew and `stow`
- **Linux**: Uses apt and `xstow`

### Manual Install
Run individual scripts as needed:
- `./zsh.sh` - ZSH configuration with modular OS-specific setups
- `./git.sh` - Git configuration
- `./nvim.sh` - Neovim configuration  
- `./tmux.sh` - Tmux configuration with TPM

## Modular ZSH Configuration

The ZSH configuration is now modular with OS detection:

- **`zsh/.zshrc`** - Common configuration and OS detection
- **`~/.config/zsh/macos.zsh`** - macOS-specific settings (Homebrew paths, GNU coreutils, etc.)
- **`~/.config/zsh/linux.zsh`** - Linux-specific settings (conda, xstow, Linux paths)
- **`~/.config/zsh/local.zsh`** - Optional machine-specific overrides (not tracked in git)

The configuration automatically detects your OS and loads the appropriate settings.

## Automatic Features

As much as possible is installed automatically via zinit:
- Powerlevel10k theme
- SDKMAN (with automatic Java/Maven management)
- Comprehensive autocompletions
- OS-specific plugin sets

## SDKMAN Integration

The configuration includes automatic SDKMAN setup. Java and Maven can be installed via:
```bash
source ./sdkman.sh
```

## Cross-Platform Support

- **macOS**: Uses Homebrew, `stow`, and macOS-specific paths
- **Linux**: Uses apt, `xstow`, and Linux-specific configurations
- Automatic detection and appropriate tool selection
