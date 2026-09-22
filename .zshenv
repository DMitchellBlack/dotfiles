# Manually configure XDG Base Directory
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Set Zsh configuration directory to follow XDG config spec
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
# Source the new .zshenv 
if [ -f "$ZDOTDIR/.zshenv" ]; then
    source "$ZDOTDIR/.zshenv"
fi
