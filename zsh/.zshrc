# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

#export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
#export PATH=$PATH:~/.kube/plugins/jordanwilson230
export WATCHMAN_SOCK=/tmp/watchman.sock

export PATH=/Library/Frameworks/Python.framework/Versions/Current/bin:/opt/homebrew/Cellar/helm@2/2.17.0/bin:~/.kube/plugins/jordanwilson230:~/.local/bin:/usr/local/bin:$PATH
export PATH=/opt/homebrew/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:$JAVA_HOME/bin:$PATH
#export PATH=$HOME/airlab/runtime_gems/tools/bin:$PATH

# Path to your oh-my-zsh installation.
export KUBE_EDITOR=nvim 
export EDITOR=nvim
export VISUAL=nvim
export CLICOLOR=YES export XDG_CONFIG_HOME=$HOME/.config
#export SSH_AUTH_SOCK=~/.gnupg/S.gpg-agent.ssh

#.0.0:8080->8080/tcp                            flexreceipts-palias jdk14='export JAVA_HOME=/usr/lib/jvm/java-14-openjdk-amd64'

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi
# prompt_context(){}

DEFAULT_USER=rustyphillips
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="gruvbox"
#SOLARIZED_THEME="dark"
PURE_POWER_MODE=modern   

HISTFILE=~/.zsh_history
SAVEHIST=1000000
HISTSIZE=1000000

setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
# Cycle through history based on characters already typed on the line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "$key[Up]" up-line-or-beginning-search
bindkey "$key[Down]" down-line-or-beginning-search

if command -v nvim &> /dev/null
then
  alias vim=nvim
  alias vi=nvim
fi

precmd() {
  if command -v setxkbmap &> /dev/null
  then
    setxkbmap -option caps:none
  fi
  if command -v xmodmap &> /dev/null
  then
    xmodmap ~/.Xmodmap 2&>/dev/null
  fi
}

__git_files () { 
    _wanted files expl 'local files' _files     
}

# Added by zi's installer
if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
  print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
  command mkdir -p "$HOME/.zi" && command chmod go-rwX "$HOME/.zi"
  command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "$HOME/.zi/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi
# examples here -> https://wiki.zshell.dev/ecosystem/category/-annexes
zicompinit # <- https://wiki.zshell.dev/docs/guides/commands

## End installer section

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zi light-mode for \
    z-shell/z-a-rust \
    z-shell/z-a-patch-dl \
    z-shell/z-a-bin-gem-node

### End of Zi's installer chunk
#
zi ice depth=1; zi light romkatv/powerlevel10k
zi snippet https://raw.githubusercontent.com/sainnhe/dotfiles/master/.zsh-theme/gruvbox-material-dark.zsh
zi wait lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

# Docker and last-working-dir apparently depend on this being set and it isn't.
mkdir -p ~$HOME/.cache/zi
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zi"
zi wait lucid for \
  OMZL::git.zsh \
  OMZP::git \
  jocelynmallon/zshmarks \
  zsh-users/zsh-autosuggestions \
  OMZP::vi-mode \
  OMZP::git-auto-fetch \
  OMZP::dotenv \
  lukechilds/zsh-nvm \
  OMZP::mvn \
  OMZP::sudo \
  chuwy/zsh-secrets \
  OMZP::last-working-dir \
  darvid/zsh-poetry
#  OMZP::docker-compose \
#  OMZP::docker \
#  OMZP::kubectl \
 
# Download the default profile for a better "ls" color set.
zi pack for dircolors-material

# Adding sdkman
zi ice as"program" pick"$ZPFX/sdkman/bin/sdk" id-as'sdkman' run-atpull \
  atclone"/opt/homebrew/bin/wget https://get.sdkman.io -O scr.sh; SDKMAN_DIR=$ZPFX/sdkman bash scr.sh" \
  atpull"SDKMAN_DIR=$ZPFX/sdkman sdk selfupdate" \
  atinit"export SDKMAN_DIR=$ZPFX/sdkman; source $ZPFX/sdkman/bin/sdkman-init.sh"
zi light z-shell/null

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vi'
 else
   export EDITOR='vi'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias ohmyzsh="mate ~/.oh-my-zsh"
# alias zshconfig="mate ~/.zshrc"
#export AWS_CBOR_DISABLE=1
#PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[green]%} %~%{$reset_color%}  |$(git_prompt_info)> '


#export AWS_REGION=us-east-1
#export AWS_DEFAULT_REGION=us-east-1

# Something is setting this automatically.  I can't find it.
unset AWS_SECRET_ACCESS_KEY
unset AWS_ACCESS_KEY_ID


export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#source "/Users/walter_phillips/.zinit/polaris/sdkman/bin/sdkman-init.sh"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# AIRLAB-DO-NOT-MODIFY section:ShellWrapper {{{
# Airlab will only make edits inside these delimiters.

# Source Airlab's shell integration, if it exists.
if [ -e ~/.airlab/shellhelper.sh ]; then
  source ~/.airlab/shellhelper.sh
fi
# AIRLAB-DO-NOT-MODIFY section:ShellWrapper }}}

source <(yak completion zsh)
###-begin-grond-completions-###
#
# yargs command completion script
#
# Installation: /opt/homebrew/bin/grond completion >> ~/.zshrc
#    or /opt/homebrew/bin/grond completion >> ~/.zsh_profile on OSX.
#

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export ANDROID_HOME="/Users/rusty.phillips/Library/Android/sdk"
export ANDROID_SDK_ROOT="/Users/rusty.phillips/Library/Android/sdk"
#export GRADLE_USER_HOME="/usr/local/share/gradle"
export M2_HOME="/usr/local/share/maven"
. $(brew --prefix asdf)/libexec/asdf.sh
eval "$(direnv hook $SHELL)"
export PATH="${PATH}:/Users/rusty.phillips/.asdf/installs/python/3.9.10/bin"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="${PATH}:$VOLTA_HOME/bin"
export PATH="${PATH}:/Users/rusty.phillips/.yarn/bin"
#eval "$(grond completion)"
#export JAVA_HOME="`/usr/libexec/java_home -v AndroidStudioJre`"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
#        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
#    else
#        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<

alias j="jump"
alias s="bookmark"
alias d="deletemark"
alias p="showmarks"
alias l="showmarks"
alias tmux='tmux -u'
#alias jdk7='sdk u java 7.0.322-zulu'
alias jdk8='sdk u java 8.0.345-zulu'
alias jdk11='sdk u java 11.0.15-zulu'
alias jdk18='sdk u java 18-amzn'
alias jdk21='sdk u java 21.0.7-amzn'

alias ls='gls --color'
alias lsc='gls -lrhtG --color'
alias make=gmake
alias find=gfind
alias grep=ggrep

jdk21
