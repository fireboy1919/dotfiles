# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=$PATH:~/.kube/plugins/jordanwilson230
# Path to your oh-my-zsh installation.
export KUBE_EDITOR=nvim 

alias jdk7='sdk u java 7.0.21-open'
alias jdk8='sdk u java 8.0.265-open'
alias jdk11='sdk u java 11.0.2-open'
alias jdk14='export JAVA_HOME=/usr/lib/jvm/java-14-openjdk-amd64'

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# prompt_context(){}

DEFAULT_USER=rustyphillips
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="gruvbox"
#SOLARIZED_THEME="dark"
PURE_POWER_MODE=modern   

SAVEHIST=1000000
setopt HIST_IGNORE_DUPS
alias vim=nvim
alias vi=nvim
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
export AWS_CBOR_DISABLE=1
#PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[green]%} %~%{$reset_color%}  |$(git_prompt_info)> '


#export AWS_REGION=us-east-1
#export AWS_DEFAULT_REGION=us-east-1

# Something is setting this automatically.  I can't find it.
unset AWS_SECRET_ACCESS_KEY
unset AWS_ACCESS_KEY_ID

alias g="jump"
alias s="bookmark"
alias d="deletemark"
alias p="showmarks"
alias l="showmarks"
alias tmux='tmux -u'
alias assume-role='assumerole'

#alias  `aws-google-auth -u rusty.phillips@flexengage.com -p dev -I C01pojxkm -S 216509506152 --print-creds -d 28800`
#alias login-`aws-google-auth -u rusty.phillips@flexengage.com -p dev -I C01pojxkm -S 216509506152 --print-creds -d 28800`

ST=/usr/bin/secret-tool
LOGIN="google-login"
LABEL="Login for Google Suite"
GOOGLE_AUTH="/usr/local/bin/gsts"
GOOGLE_USER="rusty.phillips@flexengage.com"

alias kdev="kenv dev"
alias ktest="kenv test"
alias kprod="kenv prod"

kenv() {
  PROFILE="$1"
  awslogin $PROFILE
  shift
  kubectl --context $PROFILE-aws "$@"
}

assumerole() {
  # By default, if it already exists, it doesn't set it.
  unset $(printenv | sed 's;=.*;;' | grep AWS) || 0
  eval $(command ~/go/bin/assume-role $@ )
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

    echo "$GOOGLE_AUTH --username $GOOGLE_USER --idp-id C01pojxkm --sp-id 216509506152 --aws-profile $PROFILE --aws-role-arn $ROLE"
    $GOOGLE_AUTH --username=$GOOGLE_USER --idp-id=C01pojxkm --sp-id=216509506152 --aws-profile=$PROFILE --aws-role-arn=$ROLE
  fi
  assumerole $PROFILE 
  export AWS_REGION=us-east-1
  export AWS_DEFAULT_REGION=us-east-1

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
      echo "Starting Localstack:latest"
      docker run --name=localstack -it -d -p 4566-4578:4566-4578 -p 8055:8055 -e AWS_REGION='us-east-1' -e DEFAULT_REGION='us-east-1' -e SERVICES='kinesis,dynamodb,s3,sqs,sns,ses' -e PORT_WEB_UI=8055 localstack/localstack:0.10.8
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
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk
#
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit snippet https://github.com/sainnhe/dotfiles/raw/master/.zsh-theme-gruvbox-material-dark
zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

zinit wait lucid for \
  OMZP::docker/_docker \
  OMZL::git.zsh \
  OMZP::git \
  jocelynmallon/zshmarks \
  OMZP::kubectl \
  OMZP::docker-compose \
  OMZP::git-auto-fetch \
  OMZP::last-working-dir \
  OMZP::dotenv

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [[ ! -f $HOME/.sdkman/bin/sdkman-init ]]; then
  zinit wait lucid for matthieusb/zsh-sdkman
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi 

