# General aliases
alias mwinit='mwinit -f'
alias editstuff='nvim ~/dotfiles'
alias reload="source $ZDOTDIR/.zshrc"
alias gavinabo="ssh gavinabo-east.aka.corp.amazon.com"
alias txt="adb shell input text"
alias path="echo $PATH | tr ':' '\n'"
alias ..='cd ..'
alias ls='ls -Ghp'
alias ll='ls -Gphaltr'
alias t='tree -a -C -I ".git" --gitignore --dirsfirst'

# Git aliases
alias g="git"
alias gi="git init"
alias gs="git status -sbu"
alias gco="git checkout"
alias gcob="git checkout -b"
alias ga="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gpl="git pull"
alias gps="git push"
alias gst="git stash"
alias gstl="git stash list"
alias glg='git log --graph --oneline --decorate --all'
