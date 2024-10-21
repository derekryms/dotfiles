# zsh Options
setopt HIST_IGNORE_ALL_DUPS

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# Activate syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Activate autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Aliases
# System
alias c='clear'
alias e='exit'
alias ll='ls -lah'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gqc='git add . && git commit -m'
alias gpush='git push'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gpull='git pull'
