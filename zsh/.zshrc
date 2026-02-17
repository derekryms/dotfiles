# Source oh my posh except for apple terminal
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/oh-my-posh.toml)"
fi

# Source fzf
source <(fzf --zsh)

# Source nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Source homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="/opt/homebrew/opt/ruby/bin:$HOMEBREW_PREFIX/lib/ruby/gems/4.0.0/bin:$PATH"

# Source rust
. "$HOME/.cargo/env"

# Aliases
alias ls='ls --color'
alias lg='lazygit'

# Source zsh plugins
# NOTE: Syntax highlighing must be at the end of file
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="$HOME/.local/bin:$PATH"
