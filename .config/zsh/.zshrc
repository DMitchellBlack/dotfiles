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

# ----------------------------------------------------------------------
# Prompt & Keybindings
# ----------------------------------------------------------------------
# Two-line prompt: user@full-host + path on line 1, prompt symbol on line 2
PROMPT=$'%K{#393552}%n@%M%k %B%F{#9ccfd8}%~\n%F{white} %# %b%f%k'

# The Z-Shell Line Editor (zle): https://zsh.sourceforge.io/Guide/zshguide04.html
bindkey -v # Use vi bindings (aliases 'main' keymap to 'viins')
bindkey -M viins '^?' backward-delete-char # Allow Backspace to delete past insert-mode start
# bindkey -e # Use emacs (the default) bindings, even if editor is set to vi

# If Ghostty's built-in cursor integration isn't active (e.g. over SSH or in tmux),
# switch cursor shape between block (vicmd) and bar (viins) in ZLE.
if [[ "$GHOSTTY_SHELL_FEATURES" != *cursor* ]]; then
  function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 == block ]]; then
      print -n '\e[2 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ -z ${KEYMAP} ]] || [[ $1 == beam ]]; then
      print -n '\e[6 q'
    fi
  }
  zle -N zle-keymap-select

  function zle-line-init {
    print -n '\e[6 q'
  }
  zle -N zle-line-init

  # Reset cursor to terminal default before running a command so it doesn't leak
  function zle-line-finish {
    print -n '\e[0 q'
  }
  zle -N zle-line-finish
fi

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
