#!/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

if ! command_exists brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-fzf-history-search" ]; then
    echo "Installing zsh-fzf-history-search..."
    git clone https://github.com/joshskidmore/zsh-fzf-history-search.git $ZSH_CUSTOM/plugins/zsh-fzf-history-search
fi

echo "Installing Catppuccin theme..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/catppuccin-zsh" ]; then
    git clone https://github.com/JannoTjarks/catppuccin-zsh.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/catppuccin-zsh
fi

echo "Installing Gruvbox theme..."
curl -L https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme > ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/gruvbox.zsh-theme

echo "Installing necessary tools..."

if ! command_exists tree; then
    brew install tree
fi

if ! command_exists neovim; then
    brew install neovim
fi

if ! command_exists fzf; then
    brew install fzf
fi

if ! command_exists stow; then
    brew install stow
fi

echo "Setting up dotfiles..."
cd ~/dotfiles
stow -R zsh

if ! command_exists bun; then
    echo "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
else
    echo "Bun is already installed."
fi

echo "Installation complete! Please restart your terminal or run 'source ~/.zshrc' to apply changes."
