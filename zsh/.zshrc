# Modular ZSH Configuration with OS Detection

# Common environment variables and basic settings
export KUBE_EDITOR=nvim
export EDITOR=nvim
export VISUAL=nvim
export XDG_CONFIG_HOME=$HOME/.config

# Add dotfiles zsh scripts to PATH
export PATH="$HOME/dotfiles/zsh:$PATH"

# Ensure SSH agent is running and keys are loaded
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
    # Add your SSH keys (adjust path as needed)
    ssh-add ~/.ssh/id_rsa 2>/dev/null || ssh-add ~/.ssh/id_ed25519 2>/dev/null || true
fi

# Common aliases
alias j="jump"
alias s="bookmark"
alias d="deletemark"
alias p="showmarks"
alias l="showmarks"
alias tmux='tmux -u'

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

DEFAULT_USER=rustyphillips
PURE_POWER_MODE=modern   

# History configuration
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

# Common nvim setup
if command -v nvim &> /dev/null
then
  alias vim=nvim
  alias vi=nvim
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vi'
else
   export EDITOR='vi'
fi

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Something is setting this automatically.  I can't find it.
unset AWS_SECRET_ACCESS_KEY
unset AWS_ACCESS_KEY_ID

# Common Google Auth settings
ST=/usr/bin/secret-tool
LOGIN="google-login"
LABEL="Login for Google Suite"
GOOGLE_AUTH="/usr/local/bin/gsts"
GOOGLE_USER="rusty.phillips@flexengage.com"

# Common kubectl aliases
alias kdev="kenv dev"
alias ktest="kenv test"
alias kprod="kenv prod"

# Common functions
kenv() {
  PROFILE="$1"
  awslogin $PROFILE
  shift
  kubectl --context $PROFILE-aws "$@"
}

awslogin() {
  PROFILE=$1
  if [ $PROFILE != "prod" ]
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

    $GOOGLE_AUTH --username=$GOOGLE_USER --idp-id=C01pojxkm --sp-id=216509506152 --aws-profile=$PROFILE --aws-role-arn=$ROLE --clean
    cp ~/.cache/gsts/credentials ~/.aws/credentials
  fi
  assumerole $PROFILE 

  export AWS_REGION=us-east-1
  export AWS_DEFAULT_REGION=us-east-1
  export | grep AWS > ~/.aws_env    
  aienv
}

# Common Docker management functions
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
        docker run -d -p 9000:9000 --name portainer -v //var/run/docker.sock:/var/run/docker.sock -v portainer-data:/data portainer/portainer:latest
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
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk

# Theme and common plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit snippet https://raw.githubusercontent.com/sainnhe/dotfiles/master/.zsh-theme/gruvbox-material-dark.zsh
zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

zinit wait lucid for \
  OMZL::git.zsh \
  OMZP::git \
  jocelynmallon/zshmarks \
  zsh-users/zsh-autosuggestions \
  OMZP::vi-mode \
  OMZP::kubectl \
  OMZP::git-auto-fetch \
  OMZP::last-working-dir \
  OMZP::dotenv \
  OMZP::podman \
  OMZP::rbenv \
  OMZP::mvn \
  OMZP::sudo \
  chuwy/zsh-secrets \
  lukechilds/zsh-nvm

# Cross-platform SDKMAN setup
WGET_CMD=""
if command -v wget >/dev/null 2>&1; then
    WGET_CMD="wget"
elif command -v /opt/homebrew/bin/wget >/dev/null 2>&1; then
    WGET_CMD="/opt/homebrew/bin/wget"
fi

if [[ -n "$WGET_CMD" ]]; then
    zinit ice as"program" pick"$ZPFX/sdkman/bin/sdk" id-as'sdkman' run-atpull \
      atclone"$WGET_CMD https://get.sdkman.io -O scr.sh; SDKMAN_DIR=$ZPFX/sdkman bash scr.sh" \
      atpull"SDKMAN_DIR=$ZPFX/sdkman sdk selfupdate" \
      atinit"export SDKMAN_DIR=$ZPFX/sdkman; source $ZPFX/sdkman/bin/sdkman-init.sh"
    zinit light zdharma-continuum/null
fi

zinit ice wait"0" from"gh-r" as"program" mv"mise* -> mise" atload'eval "$(mise activate zsh)"'
zinit load jdx/mise

# Load OS-specific configuration from dotfiles directory
DOTFILES_DIR="$HOME/dotfiles/zsh"
case "$(uname -s)" in
    Darwin*)
        [[ -f "$DOTFILES_DIR/macos.zsh" ]] && source "$DOTFILES_DIR/macos.zsh"
        ;;
    Linux*)
        [[ -f "$DOTFILES_DIR/linux.zsh" ]] && source "$DOTFILES_DIR/linux.zsh"
        ;;
esac

# Load local overrides (machine-specific, not in git)
[[ -f ~/.config/zsh/local.zsh ]] && source ~/.config/zsh/local.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Unset GRADLE_USER_HOME at the end to override any plugin settings
unset GRADLE_USER_HOME
