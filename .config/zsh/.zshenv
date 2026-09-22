# Manually configure XDG Base Directory
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Homebrew options
export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications --fontdir=$HOME/Library/Fonts"

# Specify directories to keep $HOME cleaner
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql/history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export PYLINTHOME="$XDG_STATE_HOME/pylint"

# Set default editor
export EDITOR="nvim"
export VISUAL="nvim"
