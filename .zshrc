# Shell Configuration
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt hist_ignore_dups  # Ignore duplicate commands in history
setopt hist_ignore_space # Ignore commands starting with a space
setopt share_history     # Share command history across sessions

# Enable Auto-completion and Key Bindings
autoload -U compinit
compinit
bindkey -e  # Emacs keybindings (e.g., Ctrl-a, Ctrl-e)

# Path Management
function addToPath {
  case ":$PATH:" in
    *":$1:"*) :;; # Already exists
    *) PATH="$1:$PATH";;
  esac
}
addToPath /usr/local/bin
addToPath /usr/local/sbin
addToPath $HOME/bin

#### Aliases
alias vim=nvim

# Git Configuration
alias gcl="git clone"
alias gco="git checkout"
alias gp="git push"
alias gs="git status"
alias gd="git diff --color-words='[A-z_0-9-]+|[0-9.]+|[^ ]'"
alias glgga='git log --graph --decorate --all'

# docker
alias dc="docker-compose"

# Node.js and NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load nvm bash_completion

# Tmux Integration (Optional for Codespaces)
if [ $SHLVL = 1 ]; then
  if command -v tmux &> /dev/null; then
    if [ "${SSH_CONNECTION-}" != "" ]; then
      tmux a -d || tmux
    else
      tmux
    fi
  fi
fi

# Powerline (Optional)
if [ "$USE_POWERLINE" = "true" ]; then
  # Ensure Powerline is installed
  if command -v powerline-daemon &> /dev/null; then
    powerline-daemon -q
    POWERLINE_CONFIG=/usr/local/lib/python3.10/dist-packages/powerline/config_files
    export POWERLINE_CONFIG
    export POWERLINE_COMMAND=powerline
    export PATH=$PATH:/usr/local/bin
    export PS1="\$(powerline-shell --shell zsh \$?)"
  else
    echo "Powerline is not installed. Skipping configuration."
  fi
fi


# Final Configurations
setopt auto_cd  # Automatically change to directory if valid
setopt auto_menu  # Show completion menu automatically
setopt no_beep  # Disable beep sound on completion errors
setopt list_packed  # Compact completion list display
