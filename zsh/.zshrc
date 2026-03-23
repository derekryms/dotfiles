# Source oh my posh except for apple terminal
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  # if [ "$TERM_PROGRAM" != "Apple_Terminal" ] && [ "$TERM_PROGRAM" != "WezTerm" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/oh-my-posh.toml)"
fi

# Vi in terminal
bindkey -v
export KEYTIMEOUT=10 # Remove ESC key timeout delay (100ms)
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne "\e[2 q" # Block cursor for normal mode
  else
    echo -ne "\e[6 q" # Vertical bar for insert mode
  fi
}
zle -N zle-keymap-select
echo -ne "\e[6 q" # Start with bar cursor

# Set history file location
export HISTFILE=~/.zsh_history

# Increase history size (number of commands to remember)
export HISTSIZE=10000 # In-memory history
export SAVEHIST=10000 # Saved to file

# History options
setopt EXTENDED_HISTORY     # Save timestamp and duration of commands
setopt INC_APPEND_HISTORY   # Append to history file immediately (survives crashes)
setopt SHARE_HISTORY        # Share history across terminals
setopt HIST_IGNORE_DUPS     # Don't save duplicate consecutive commands
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicate entries when new one is added
setopt HIST_FIND_NO_DUPS    # Don't show duplicates when searching through history
setopt HIST_REDUCE_BLANKS   # Remove extra blanks from history
setopt HIST_SAVE_NO_DUPS    # Don't save duplicates to history file

# Source fzf
source <(fzf --zsh)

# Source nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Source homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Claude path
export PATH="$HOME/.local/bin:$PATH"

#Added for lazygit config file location on macos
export XDG_CONFIG_HOME="$HOME/.config"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/dryms/.docker/completions $fpath)
autoload -Uz compinit
compinit

# Aliases
alias ls='ls --color'
alias lg='lazygit'

# Source zsh plugins
# NOTE: Syntax highlighing must be at the end of file
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
