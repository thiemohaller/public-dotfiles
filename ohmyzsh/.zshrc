# Set Zsh as the default shell
export SHELL=/bin/zsh
export ZSH=$HOME/.oh-my-zsh

# Path to your oh-my-zsh installation.
ZSH_THEME="robbyrussell"

# Enable plugins
plugins=(
    git
    zsh-autosuggestions
    )

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Aliases
alias ll='ls -lah'
alias gs='git status'

# Custom prompt
# PROMPT='%n@%m %1~ %# '

# Preferred editor
export EDITOR='nano'

# History settings
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
# Custom prompt with Nerd Font icons
PROMPT='%F{green}➜ %F{blue}%c%f $(git_prompt_info)%f '

# Git prompt information
ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow} "  # Branch icon
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"            # Reset color
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red} ✗%f"    # Dirty state icon
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green} ✓%f"  # Clean state icon

# Function to display git info
function git_prompt_info() {
  local ref
  ref=$(git symbolic-ref --short HEAD 2> /dev/null) || ref=$(git describe --tags --exact-match 2> /dev/null)
  if [[ -n "$ref" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$ref$ZSH_THEME_GIT_PROMPT_SUFFIX"
    if [[ -n $(git status --porcelain) ]]; then
      echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
      echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
  fi
}