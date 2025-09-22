# Linux-specific configurations

# Linux PATH settings
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=$PATH:~/.kube/plugins/jordanwilson230

# Linux-specific aliases
alias lsc='ls --sort=time -rlh --color'

# Linux-specific keymap management with timing
precmd() {
  local current_time=$(date +%s)
  local last_keymap_time=${LAST_KEYMAP_TIME:-0}
  local time_diff=$((current_time - last_keymap_time))
  
  if [ $time_diff -ge 1800 ]; then
    if command -v setxkbmap &> /dev/null
    then
      setxkbmap -option caps:none
    fi
    if command -v xmodmap &> /dev/null
    then
      xmodmap ~/.Xmodmap 2&>/dev/null
    fi
    export LAST_KEYMAP_TIME=$current_time
  fi
}

# Linux-specific AWS environment variables (currently active)
export AWS_CBOR_DISABLE=1
export AWS_REGION=us-east-1
export AWS_DEFAULT_REGION=us-east-1

# Linux assume-role alias and function
alias assume-role='assumerole'

assumerole() {
  # By default, if it already exists, it doesn't set it.
  unset $(printenv | sed 's;=.*;;' | grep AWS) || 0
  eval $(command ~/go/bin/assume-role $@ )
}

# Linux AI environment setup function
aienv() {
   # Create a temporary file to store AWS env vars
    local temp_file=$(mktemp)
    local settings_file="$HOME/.claude/settings.json"

    # Source the AWS env file to a temporary file as JSON
    set -a
    source ~/.aws_env
    env | grep "^AWS_" | jq -R 'split("=") | {(.[0]): .[1]}' | jq -s add > "$temp_file"
    set +a

    # Create the settings.json file with env section
    jq -n --argjson aws_vars "$(cat $temp_file)" '{"env": ($aws_vars + {"CLAUDE_CODE_USE_BEDROCK": "1", "ANTHROPIC_MODEL": "us.anthropic.claude-sonnet-4-20250514-v1:0", "ANTHROPIC_SMALL_MODEL": "us.anthropic.claude-3-5-haiku-20241022-v1:0"})}' > "$settings_file"

    # Remove temporary file
    rm "$temp_file"
    echo "Environment variables saved to $settings_file"
}

# Linux-specific Claude AI shortcuts
airesume() {
  awslogin sandbox
  CLAUDE_CODE_USE_BEDROCK=1 ANTRHOPIC_MODEL="us.anthropic.claude-sonnet-4-20250514-v1:0" ANTHROPIC_SMALL_MODEL="us.anthropic.claude-3-5-haiku-20241022-v1:0" claude -r
}

aichat() {
  claude
}

# Linux SDKMAN setup
zinit ice as"program" pick"$ZPFX/sdkman/bin/sdk" id-as'sdkman' run-atpull \
  atclone"wget https://get.sdkman.io -O scr.sh; SDKMAN_DIR=$ZPFX/sdkman bash scr.sh" \
  atpull"SDKMAN_DIR=$ZPFX/sdkman sdk selfupdate" \
  atinit"export SDKMAN_DIR=$ZPFX/sdkman; source $ZPFX/sdkman/bin/sdkman-init.sh"
zinit light zdharma-continuum/null

# Linux NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Linux conda initialization
__conda_setup="$('/home/rustyphillips/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/rustyphillips/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/rustyphillips/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/rustyphillips/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# Linux-specific Docker socket path (standard Linux)
alias portainer_start='docker run -d -p 9000:9000 --name portainer -v //var/run/docker.sock:/var/run/docker.sock -v portainer-data:/data portainer/portainer:latest'

# Linux JDK aliases (original versions)
alias jdk8='sdk u java 8.0.265-open'
alias jdk11='sdk u java 11.0.28-amzn'
alias jdk17='sdk u java 17.0.15-amzn'

# Linux-specific k9s context
k9() {
  env="$1"
  awslogin $env
  k9s --context $env
}