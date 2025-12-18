#!/usr/bin/env bash

echo

# Check if curl is installed
if ! command -v curl >/dev/null 2>&1; then
    echo -e "Please install curl then run the install script again.\n"
    exit 1
fi

# Look for and source nvm for script session
if [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"
fi

# Install nvm if not already installed
if ! command -v nvm >/dev/null 2>&1; then
    echo -e "Installing nvm v0.40.3 ...\n"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# Install homebrew if not already installed
if ! command -v brew >/dev/null 2>&1; then
    echo -e "Installing homebrew ...\n"
    /usr/bin/env bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install/Update homebrew packages
packages=(
  "stow"
  "oh-my-posh"
  "zsh-autosuggestions"
  "zsh-syntax-highlighting"
)

for pkg in "${packages[@]}"; do
  brew install "$pkg"
  echo
done

echo -e "Install Script Ran Successfully!\n"
