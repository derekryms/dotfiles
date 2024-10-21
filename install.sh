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
if ! command -v brew &>/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

info "Installing Stow..."
brew install stow

info "Cloning dotfiles repo..."
dotfilesDir=~/dotfiles
if [ -d $dotfilesDir ]; then 
	git -C $dotfilesDir pull
else 
	git clone https://github.com/derekryms/dotfiles.git $dotfilesDir 
fi

info "Create symlinks..."
stow -d $dotfilesDir   -t ~ .
