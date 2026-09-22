# Ensure PATH entries stay unique
typeset -U path PATH

# Set up Homebrew (prepends /opt/homebrew/bin and /opt/homebrew/sbin)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Prepend local binaries so personal tools take precedence
path=("$HOME/.local/bin" $path)
export PATH
