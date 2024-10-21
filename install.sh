#!/bin/bash

default_color=$(tput sgr 0)
red="$(tput setaf 1)"
yellow="$(tput setaf 3)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"

info() {
	printf "%s==> %s%s\n" "$blue" "$1" "$default_color"
}

success() {
	printf "%s==> %s%s\n" "$green" "$1" "$default_color"
}

error() {
	printf "%s==> %s%s\n" "$red" "$1" "$default_color"
}

warning() {
	printf "%s==> %s%s\n" "$yellow" "$1" "$default_color"
}

info "Installing Homebrew..."
if command -v brew &>/dev/null; then
	warning "Homebrew already installed"
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

info "Cloning dotfiles repo..."
if [ -d "~/dotfiles" ]; then
	warning "The dotfiles directory already exist"
else
	git clone https://github.com/derekryms/dotfiles.git ~/dotfiles
fi

info "Source zshrc..."
source ~/dotfiles/.zshrc

info "Installing Neovim..."
brew install neovim
