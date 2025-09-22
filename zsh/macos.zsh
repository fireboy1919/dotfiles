# macOS-specific configurations

# PATH settings for macOS
export PATH=/Library/Frameworks/Python.framework/Versions/Current/bin:/opt/homebrew/Cellar/helm@2/2.17.0/bin:~/.kube/plugins/jordanwilson230:~/.local/bin
export PATH=/opt/homebrew/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:$JAVA_HOME/bin:$PATH
export PATH=$HOME/airlab/runtime_gems/tools/bin:$PATH

# macOS-specific environment variables  
export CLICOLOR=YES

# macOS-specific aliases (using GNU coreutils)
alias ls='gls --color'
alias lsc='gls -lrhtG --color'
alias make=gmake

# macOS-specific zinit plugins
zinit wait lucid for \
  OMZP::last-working-dir \
  OMZP::docker/_docker \
  OMZP::docker \
  OMZP::docker-compose \
  OMZP::rbenv \
  OMZP::mvn \
  OMZP::sudo \
  chuwy/zsh-secrets

# Download the default profile for a better "ls" color set.
zinit pack for dircolors-material

# macOS NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# macOS-specific SDKMAN setup
zinit ice as"program" pick"$ZPFX/sdkman/bin/sdk" id-as'sdkman' run-atpull \
  atclone"/opt/homebrew/bin/wget https://get.sdkman.io -O scr.sh; SDKMAN_DIR=$ZPFX/sdkman bash scr.sh" \
  atpull"SDKMAN_DIR=$ZPFX/sdkman sdk selfupdate" \
  atinit"export SDKMAN_DIR=$ZPFX/sdkman; source $ZPFX/sdkman/bin/sdkman-init.sh"
zinit light zdharma-continuum/null

# Source SDKMAN init for macOS user path
source "/Users/walter_phillips/.zinit/polaris/sdkman/bin/sdkman-init.sh"

# macOS-specific development tools
source <(yak completion zsh)

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
eval "$(grond completion)"

# macOS Java setup
export JAVA_HOME="`/usr/libexec/java_home -v AndroidStudioJre`"

# macOS-specific Docker socket path
alias portainer_start='docker run -d -p 9000:9000 --name portainer -v /Users/rusty.phillips/.docker/run/docker.sock:/var/run/docker.sock -v portainer-data:/data portainer/portainer-ce:latest'

# macOS JDK aliases (updated versions)
alias jdk8='sdk u java 8.0.345-zulu'
alias jdk11='sdk u java 11.0.15-zulu'
alias jdk18='sdk u java 18-amzn'

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