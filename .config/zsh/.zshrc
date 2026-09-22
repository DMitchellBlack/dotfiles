# .zshrc - Interactive ZSH configuration

# ----------------------------------------------------------------------
# Core Settings & History
# ----------------------------------------------------------------------
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY # Import new commands from history and appends typed commands. History lines are output with timestamps.
setopt HIST_IGNORE_DUPS # Don't record an entry that was just recorded
setopt HIST_REDUCE_BLANKS # Remove unnecessary blank lines.

export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$HOST"

# Ensure state and cache directories exist
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"
[[ -d "${ZSH_COMPDUMP:h}" ]] || mkdir -p "${ZSH_COMPDUMP:h}"

# Use vi keybindings
bindkey -v

# ----------------------------------------------------------------------
# Prompt Setup
# ----------------------------------------------------------------------
autoload -Uz promptinit; promptinit
prompt adam1

# ----------------------------------------------------------------------
# Completion System
# ----------------------------------------------------------------------
# See: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

# Filter completion matches with magic patterns
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# Set up completion menu
zstyle ':completion:*' menu select=2
zstyle ':completion:*' menu select=long

# Group completion choices by tag
zstyle ':completion:*' group-name ''

# Colorize completion lists
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Don't fall back to legacy `compctl` completion system
zstyle ':completion:*' use-compctl false

# Complete special directories (., .., ~)
zstyle ':completion:*' special-dirs true

# ----------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------
# Better `ls`
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -alF'
# Instant create / resume tmux session
alias tmux-dev="tmux new-session -A -s DEV"
alias nv='nvim'
# Open man pages with Neovim
alias vman="MANPAGER='nvim +Man!' man"

# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------
########################################
# Pretty-print the PATH environment variable.
# Globals:
#   PATH
########################################
function ppath() {
    echo $PATH | sed 's/:/\n/g'
}
