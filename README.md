# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

### Homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Ensure to add the following to the .zprofile

```
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Stow

```
brew install stow
```

### Neovim

```
brew install neovim
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com/derekryms/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks

```
$ stow .
```
