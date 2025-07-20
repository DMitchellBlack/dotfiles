# Manually configure XDG Base Directory
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Update Homebrew default install locations
export HOMEBREW_CASK_OPTS="--appdir=~/Applications --fontdir=~/Library/Fonts"
# Java home, installed from homebrew
export JAVA_HOME="/usr/local/Cellar/openjdk/22.0.2"

# Specify directories to keep $HOME cleaner
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql/history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export PYLINTHOME="$XDG_STATE_HOME/pylint"

# Set default editor
export EDITOR="nvim"

# Path to Oh My Zsh installation
export ZSH="$HOME/.local/ohmyzsh"
export ZSH_THEME=""
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/ohmyzsh"
export ZSH_COMPDUMP="$XDG_STATE_HOME/ohmyzsh"
# Standard plugins can be found in `$ZSH/plugins`. Must be set before oh-my-zsh
# is sourced.
plugins=()
source $ZSH/oh-my-zsh.sh

# Easy viewing of path
function path() {
  echo $PATH | sed 's/:/\n/g'
}

# Add binaries from ~/.local/bin` to path.
export PATH="$PATH:$HOME/.local/bin"

# Source aliases
if [ -f ~/.zsh_aliases ]; then
  . ~/.zsh_aliases
fi

# Use tab completion library
autoload -Uz compinit && compinit

# Autoload zsh's `vcs_info` function
# (-U autoload w/o substition, -z use zsh style)
autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git
# Add Git branch details in form of "git({branch})"
zstyle ":vcs_info:git:*" formats "%s(%b) "

# Trigger `vcs_info` function before each command
function precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

setopt prompt_subst
# In {cyan}, add 1 element of current path
PROMPT="%1{➜%} %F{cyan}%1~%f "
# Add {blue} version control info
# **NOTE**: The string including vcs_info must be in single quotes (`'`) so it
# is evaulated at the right time. To check run `> echo $PROMPT` and confirm that
# the output includes the literal "${vcs_info_msg_0_}", meaning it has not been
# evaulated yet.
PROMPT+='%F{blue}${vcs_info_msg_0_}%f'
# Make foreground color green or red based on the last command's exit status
PROMPT+="%(?:%F{green}>%f :%F{red}>%f ) "
