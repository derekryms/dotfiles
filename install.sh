#!/bin/bash

source scripts/printUtils.sh

info "Installing Homebrew..."
if hash brew &>/dev/null; then
	warning "Homebrew already installed"
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

info "Installing Neovim..."
brew install neovim
