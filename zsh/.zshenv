export ZDOTDIR=$HOME/.config/zsh

# Set ZSH_CACHE_DIR
export ZSH_CACHE_DIR=$HOME/.cache/zsh

# Ensure the cache directory exists
mkdir -p $ZSH_CACHE_DIR

# Set the location of the history file
export HISTFILE=$ZSH_CACHE_DIR/.zsh_history
