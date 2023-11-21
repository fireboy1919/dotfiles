# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export PATH=/Library/Frameworks/Python.framework/Versions/Current/bin:/opt/homebrew/Cellar/helm@2/2.17.0/bin:/opt/homebrew/opt/terraform@0.12/bin:/opt/homebrew/bin:$PATH:~/.kube/plugins/jordanwilson230:~/.local/bin

# Path to your oh-my-zsh installation.
export KUBE_EDITOR=nvim 
export EDITOR=nvim
export VISUAL=nvim
export CLICOLOR=YES
export XDG_CONFIG_HOME=$HOME/.config
export RECEPIENT=rusty.phillips@klarna.com

alias jdk7='sdk u java 7.0.322-zulu'
alias jdk8='sdk u java 8.0.345-zulu'
alias jdk11='sdk u java 11.0.15-zulu'
alias jdk18='sdk u java 18-amzn'
alias ls='gls --color'
alias lsc='gls -lrhtG --color'
alias make=gmake

alias j="jump"

export GOOGLE_USERNAME="rusty.phillips@flexreceipts.com" # This is your Google username - for example, john.doe@flexreceipts.com
export GOOGLE_IDP_ID="C01pojxkm"
export GOOGLE_SP_ID="216509506152"
export GOOGLE_AUTH_DURATION="28800"
export AWS_DEV_ROLE="arn:aws:iam::048502202118:role/google-idp-admin"
export AWS_TEST_ROLE="arn:aws:iam::032946347770:role/google-idp-admin"
export AWS_SANDBOX_ROLE="arn:aws:iam::167287004810:role/google-idp-admin"
export AWS_PROD_ROLE="arn:aws:iam::450266734631:role/google-idp-read-only"
export AWS_INTERNAL_ROLE="arn:aws:iam::209987143508:role/google-idp-admin"

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

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

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

alias j="jump"
alias s="bookmark"
alias d="deletemark"
alias p="showmarks"
alias l="showmarks"
alias tmux='tmux -u'

#alias  `aws-google-auth -u rusty.phillips@flexengage.com -p dev -I C01pojxkm -S 216509506152 --print-creds -d 28800`
#alias login-`aws-google-auth -u rusty.phillips@flexengage.com -p dev -I C01pojxkm -S 216509506152 --print-creds -d 28800`

ST=/usr/bin/secret-tool
LOGIN="google-login"
LABEL="Login for Google Suite"
GOOGLE_AUTH=gsts
GOOGLE_USER="rusty.phillips@flexengage.com"
GPG_KEY="rusty.phillips@klarna.com"

alias kdev="kenv dev"
alias ktest="kenv test"
alias kprod="kenv prod"

kenv() {
  PROFILE="$1"
  awslogin $PROFILE
  shift
  kubectl --context $PROFILE-aws "$@"
}

## TO USE THIS, you need gpg.  You must first run gpg --gen-key and create a GPG key.  
#  Arguments:  email (of the gpg key you created with gpg --gen-key), username, password
klarna_encrypt() {
  username=$2
  password=$3
  echo "AD_USERNAME=$username\nAD_PASSWORD=$password" | gpg -r $GPG_KEY -q --encrypt --output ~/.secrets/klarna_env.gpg
}

klarna_login() {
  account=$1
  eval $(gpg -q --decrypt ~/.secrets/klarna_env.gpg)
  eval $(aws-login-tool login -a $1 -r  iam-sync/digital-receipts/digital-receipts.IdP_admin)
}

redrive() {
  awslogin prod
  /Users/rusty.phillips/projects/alerts/runbook/general/sqs/dlq_redriver.sh
}

awslogin() {
  PROFILE=$1
  unalias gsts 2&>/dev/null
  export AWS_PROFILE=$PROFILE
  if [[ $PROFILE != "prod" ]] && [[ $PROFILE != k* ]]
  then
    case $PROFILE in
      "dev")
        ROLE="arn:aws:iam::048502202118:role/google-idp-admin"
        ;;
      "test")
        ROLE="arn:aws:iam::032946347770:role/google-idp-admin"
        ;;
      "sandbox")
        ROLE="arn:aws:iam::167287004810:role/google-idp-admin"
        ;;
      "prod")
        ROLE="arn:aws:iam::450266734631:role/google-idp-read-only"
        ;;
      "internal")
        ROLE="arn:aws:iam::209987143508:role/google-idp-admin"
        ;;
    esac
    #aws-google-auth  --bg-response js_enabled -u $GOOGLE_USER -R 'us-east-1' -I $GOOGLE_IDP_ID -S $GOOGLE_SP_ID -d $GOOGLE_AUTH_DURATION -k -p default -r $ROLE -l debug --save-saml-flow
  $GOOGLE_AUTH --aws-region=us-east-1 --username=$GOOGLE_USER --idp-id=$GOOGLE_IDP_ID --sp-id=$GOOGLE_SP_ID --aws-role-arn=$ROLE -o json | jq -r '"export AWS_ACCESS_KEY_ID="+.AccessKeyId + "\nexport AWS_SECRET_ACCESS_KEY="+.SecretAccessKey + "\nexport AWS_SESSION_TOKEN=" + .SessionToken' | source /dev/stdin
 echo $GOOGLE_AUTH --aws-region=us-east-1 --username=$GOOGLE_USER --idp-id=$GOOGLE_IDP_ID --sp-id=$GOOGLE_SP_ID --aws-role-arn=$ROLE -o json
  #export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s")
#  $(aws sts assume-role \
#    --role-arn $ROLE \
#    --role-session-name CURRENT_SESSION \
#    --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
#    --output text))

  else
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_ACCESS_KEY_ID
  fi

  if [[ $PROFILE == k* ]]
  then
    case $PROFILE in
      "kplay")
        ACCOUNT=854609004233
        ;;
      "knp")
        ACCOUNT=246126820103
        ;;
      "kprod")
        ACCOUNT=535118496902
        ;;
    esac
    klarna_login $ACCOUNT
    return 0
  fi
  kubectx $PROFILE-aws
  export AWS_REGION=us-east-1
  #export AWS_PROFILE=$PROFILE
  export AWS_DEFAULT_REGION=us-east-1
}

k9() {
  env="$1"
  awslogin $env
  k9s --context $env-aws
}

rabbitmq() {
  zparseopts -D -E -- k=kill r=restart
  [ -n "${kill}" -o -n "$restart" ] && echo "Stopping rabbitmq" && docker stop rabbit >/dev/null && echo "RabbitMQ stopped."
  if [ -n "${restart}" -o -z "${kill}" ]; then
    if [ "$(docker ps -aq -f name=rabbitmq)" ]; then
      if [ "$(docker ps -aq -f status=exited -f name=rabbitmq)" ]; then
        echo "Starting rabbitmq"
        docker start rabbitmq
        echo "RabbitMQ started"
      else
        echo "RabbitMQ already started."
      fi
    else
      echo "Starting RabbitMQ"
      docker run --name=rabbitmq -it -d -p 15672:15672 -p 5672:5672 rabbitmq:3-management
      echo "RabbitMQ started."
    fi
  fi
}


localstack() {
  zparseopts -D -E -- k=kill r=restart
  [ -n "${kill}" -o -n "$restart" ] && echo "Stopping localstack" && docker stop localstack >/dev/null && echo "Localstack stopped."
  if [ -n "${restart}" -o -z "${kill}" ]; then
    if [ "$(docker ps -aq -f name=localstack)" ]; then
      if [ "$(docker ps -aq -f status=exited -f name=localstack)" ]; then
        echo "Starting localstack"
        docker start localstack
        echo "Localstack started"
      else
        echo "Localstack already started."
      fi
    else
      echo "Starting Localstack with HOSTNAME_EXTERNAL=localstack"
      docker run --name=localstack -it -d -p 4566-4583:4566-4583 -p 8055:8055 -e AWS_REGION='us-east-1' -e DEFAULT_REGION='us-east-1' -e HOSTNAME_EXTERNAL=localstack -e SERVICES='kinesis,dynamodb,s3,sqs,sns,ses,ssm' -e PORT_WEB_UI=8055 localstack/localstack:0.10.8
      echo "Localstack started."
    fi
  fi
}

plantuml() {
  zparseopts -D -E -- k=kill r=restart
  [ -n "${kill}" -o -n "$restart" ] && echo "Stopping plantuml" && docker stop portainer>/dev/null && echo "PlantUML stopped."
  if [ -n "${restart}" -o -z "${kill}" ]; then
    if [ "$(docker ps -aq -f name=plantuml)" ]; then
      if [ "$(docker ps -aq -f status=exited -f name=plantuml)" ]; then
        echo "Starting plantuml server"
        docker start plantuml
        echo "PlantUML started"
      else
        echo "PlantUML already started."
      fi
    else
      echo "Starting plantuml-server"
        docker run -d -p 9999:8080 --name plantuml plantuml/plantuml-server:jetty
      echo "PlantUML-server started"
    fi
  fi

}

portainer() {
  zparseopts -D -E -- k=kill r=restart
  [ -n "${kill}" -o -n "$restart" ] && echo "Stopping portainer" && docker stop portainer>/dev/null && echo "Portainer stopped."
  if [ -n "${restart}" -o -z "${kill}" ]; then
    if [ "$(docker ps -aq -f name=portainer)" ]; then
      if [ "$(docker ps -aq -f status=exited -f name=portainer)" ]; then
        echo "Starting portainer"
        docker start portainer
        echo "Portainer started"
      else
        echo "Portainer already started."
      fi
    else
      echo "Starting portainer"
        docker run -d -p 9000:9000 --name portainer -v /Users/rusty.phillips/.docker/run/docker.sock:/var/run/docker.sock -v portainer-data:/data portainer/portainer-ce:latest
      echo "Portainer started"
    fi
  fi
}


kubedash() {
  zparseopts -D -E -- k=kill r=restart
  [ -n "${kill}" -o -n "$restart" ] && pkill -f 'kubectl proxy'
  if [ -z "${context}" ]; then
    context="dev-aws"
  fi

  if [ -n "${restart}" -o -z "${kill}" ]; then
    echo "Starting Kubernetes dashboard for $context"
    kubectl --context=$context -n kube-system describe secret $(kubectl --context=$context -n kube-system get secret | grep eks-admin | awk '{print $1}')
    nohup kubectl proxy --context=$context >/dev/null 2>&1 &
    nohup sensible-browser 'http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/pod?namespace=_all' >/dev/null 2>&1 &
  fi
}

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk
#
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit snippet https://raw.githubusercontent.com/sainnhe/dotfiles/master/.zsh-theme/gruvbox-material-dark.zsh
zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

zinit wait lucid for \
  OMZP::last-working-dir \
  OMZP::docker/_docker \
  OMZL::git.zsh \
  OMZP::git \
  jocelynmallon/zshmarks \
  zsh-users/zsh-autosuggestions \
  OMZP::vi-mode \
  OMZP::kubectl \
  OMZP::docker-compose \
  OMZP::git-auto-fetch \
  OMZP::dotenv \
  lukechilds/zsh-nvm \
  OMZP::mvn \
  OMZP::sudo \
  chuwy/zsh-secrets 
 
# Download the default profile for a better "ls" color set.
zinit pack for dircolors-material

# Adding sdkman
zplugin ice as"program" pick"$ZPFX/sdkman/bin/sdk" id-as'sdkman' run-atpull \
  atclone"/opt/homebrew/bin/wget https://get.sdkman.io -O scr.sh; SDKMAN_DIR=$ZPFX/sdkman bash scr.sh" \
  atpull"SDKMAN_DIR=$ZPFX/sdkman sdk selfupdate" \
  atinit"export SDKMAN_DIR=$ZPFX/sdkman; source $ZPFX/sdkman/bin/sdkman-init.sh"
zplugin light zdharma-continuum/null

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
###-begin-grond-completions-###
#
# yargs command completion script
#
# Installation: /opt/homebrew/bin/grond completion >> ~/.zshrc
#    or /opt/homebrew/bin/grond completion >> ~/.zsh_profile on OSX.
#
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


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export ANDROID_HOME="/Users/rusty.phillips/Library/Android/sdk"
export ANDROID_SDK_ROOT="/Users/rusty.phillips/Library/Android/sdk"
export GRADLE_USER_HOME="/usr/local/share/gradle"
export M2_HOME="/usr/local/share/maven"
. $(brew --prefix asdf)/libexec/asdf.sh
eval "$(direnv hook $SHELL)"
export PATH="${PATH}:/Users/rusty.phillips/.asdf/installs/python/3.9.10/bin"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="${PATH}:$VOLTA_HOME/bin"
export PATH="${PATH}:/Users/rusty.phillips/.yarn/bin"
eval "$(grond completion)"
export JAVA_HOME="`/usr/libexec/java_home -v AndroidStudioJre`"
