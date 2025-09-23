# macOS-specific configurations
TMPDIR="/tmp"


# Initialize key array for macOS (fix for empty key sequences)
typeset -g -A key
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}

# PATH settings for macOS - put GNU coreutils first to fix grep/find issues
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:/usr/local/bin:/Library/Frameworks/Python.framework/Versions/Current/bin:/opt/homebrew/Cellar/helm@2/2.17.0/bin:~/.kube/plugins/jordanwilson230:~/.local/bin:$JAVA_HOME/bin:$PATH
export PATH=$HOME/airlab/runtime_gems/tools/bin:$PATH

# macOS-specific environment variables
export CLICOLOR=YES
alias ls='gls --color'
alias lsc='ls -lrhtG --color'

# Start watchman with the standard socket path that COC expects
if command -v watchman >/dev/null 2>&1; then
  if ! pgrep -q watchman; then
    nice -n 0 watchman --sockname=/tmp/watchman.sock --logfile=/tmp/watchman.log --pidfile=/tmp/watchman.pid
  fi
fi

# macOS-specific aliases (using GNU coreutils)
alias make=gmake
alias vim=nvim
# No macOS-specific zinit plugins currently

# Download the default profile for a better "ls" color set.
zinit pack for dircolors-material

# macOS NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# macOS-specific development tools
if command -v yak >/dev/null 2>&1; then
  source <(yak completion zsh)
fi

# macOS Android/development environment
export ANDROID_HOME="/Users/rusty.phillips/Library/Android/sdk"
export ANDROID_SDK_ROOT="/Users/rusty.phillips/Library/Android/sdk"
export GRADLE_USER_HOME="/usr/local/share/gradle"
export M2_HOME="/usr/local/share/maven"

# macOS-specific tool integrations
. $(brew --prefix asdf)/libexec/asdf.sh
eval "$(direnv hook $SHELL)"
export PATH="${PATH}:/Users/rusty.phillips/.asdf/installs/python/3.9.10/bin"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="${PATH}:$VOLTA_HOME/bin"
export PATH="${PATH}:/Users/rusty.phillips/.yarn/bin"
if command -v grond >/dev/null 2>&1; then
  eval "$(grond completion)"
fi

# macOS Java setup
export JAVA_HOME="`/usr/libexec/java_home -v AndroidStudioJre`"

# Docker removed - not installed

# AIRLAB integration (macOS)
if [ -e ~/.airlab/shellhelper.sh ]; then
  source ~/.airlab/shellhelper.sh
fi

# macOS-specific completions
###-begin-grond-completions-###
_grond_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" /opt/homebrew/bin/grond --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _grond_yargs_completions grond
###-end-grond-completions-###

# Generated for envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
