# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/rustyphillips/.oh-my-zsh"
export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')

DEFAULT_USER=rustyphillips
prompt_context(){}
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

SAVEHIST=1000000
setopt HIST_IGNORE_DUPS

precmd() {
  setxkbmap -option caps:none
  xmodmap ~/.Xmodmap 2&>/dev/null
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
plugins=(
  git zshmarks kubectl docker docker-compose git-auto-fetch terraform aws last-working-dir zsh-completions
  )

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='vim'
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
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export AWS_CBOR_DISABLE=1
#PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[green]%} %~%{$reset_color%}  |$(git_prompt_info)> '


export AWS_REGION=us-east-1
export AWS_DEFAULT_REGION=us-east-1

# Something is setting this automatically.  I can't find it.
unset AWS_SECRET_ACCESS_KEY
unset AWS_ACCESS_KEY_ID

alias g="jump"
alias s="bookmark"
alias d="deletemark"
alias p="showmarks"
alias l="showmarks"
alias assume-role='function(){eval $(command ~/go/bin/assume-role $@);}'
alias tmux='tmux -u'

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
      echo "Starting Localstack"
      docker run --name=localstack -it -d -p 4567-4578:4567-4578 -e SERVICES='kinesis,dynamodb,s3,sqs,sns,ses' localstack/localstack 
      echo "Localstack started."
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

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/rustyphillips/.sdkman"
[[ -s "/home/rustyphillips/.sdkman/bin/sdkman-init.sh" ]] && source "/home/rustyphillips/.sdkman/bin/sdkman-init.sh"