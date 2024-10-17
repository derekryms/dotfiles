#!/bin/zsh

homebrewEval='eval "$(/opt/homebrew/bin/brew shellenv)"'
echo "Installing homebrew"
if ! command -v brew &> /dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo -e "\nAdding homebrew to PATH"
	if ! grep -Fxq "$homebrewEval" ~/.zprofile; then
		echo "$homebrewEval" >> ~/.zprofile
		echo -e "\nSourcing .zprofile in this session"
		source ~/.zprofile
	else
		echo "Homebrew already added to PATH"
	fi
else
	echo "Homebrew is already installed"
	echo "Updating homebrew"
	brew update
fi

echo -e "\nInstall stow"
brew install stow

echo -e "\nInstall neovim"
brew install neovim

echo -e "\nInstall ripgrep"
brew install ripgrep

echo -e "\nInstall fd"
brew install fd

echo -e "\nInstall alacritty"
brew install --cask alacritty

echo -e "\nInstall wezterm"
brew install --cask wezterm

echo -e "\nInstall starship"
brew install startship

echo -e "\nInstall zsh-syntax-highlighting"
brew install zsh-syntax-highlighting

echo -e "\nInstall zsh-autosuggestions"
brew install zsh-autosuggestions

dotfilesPath=~/dotfiles
echo -e "\nClone dotfiles repo"
if [ -d "$dotfilesPath" ]; then
	echo "Dotfiles files folder already exist"
	echo "Pulling latest changes"
	git checkout main
	git pull
else
	git clone https://github.com/derekryms/dotfiles.git "$dotfilesPath"
fi

echo -e "\nRun stow to create symlinks"
cd ~/dotfiles
stow .
