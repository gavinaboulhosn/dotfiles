export ZDOTDIR=$HOME/.config/zsh
export ZSH_CACHE_DIR=$HOME/.cache/zsh
export HISTFILE=$ZSH_CACHE_DIR/.zsh_history
export ZSH="$HOME/.oh-my-zsh"
export DOCKER_HOST=unix:///Applications/Finch/lima/data/finch/sock/finch.sock

# Theme
# ZSH_THEME="gruvbox"
ZSH_THEME="catppuccin"
CATPPUCCIN_FLAVOR="mocha" # Options: mocha, frappe, macchiato, latte
CATPPUCCIN_SHOW_TIME=true

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-fzf-history-search
    z
    colorize
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration
# Path additions
export PATH=$PATH:/Users/gavinabo/.toolbox/bin
eval "$(/opt/homebrew/bin/brew shellenv)"

for config_file ($HOME/.config/zsh/*.zsh(N) $HOME/.config/zsh/amazon/*.zsh(N)); do
  source $config_file
done

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Vim mode
set -o vi

# Bun completions
[ -s "/Users/gavinabo/.bun/_bun" ] && source "/Users/gavinabo/.bun/_bun"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Set zsh options
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB
setopt CORRECT
setopt INTERACTIVE_COMMENTS

# Load custom functions
autoload -U compinit && compinit
eval "$(rbenv init -)"
. "$HOME/.cargo/env"
