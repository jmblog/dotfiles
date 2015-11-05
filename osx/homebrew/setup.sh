#!/usr/bin/env bash

brew update
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install bash 4
brew install bash

# Install Ag
brew install the_silver_searcher

# Install ColorDiff
brew install colordiff

# Install tree
brew install tree

# Install wget
brew install wget

# Install vim
brew install vim

# Install htop
brew install htop

#----------------------
# Install native apps
#----------------------
brew install caskroom/cask/brew-cask

brew tap caskroom/fonts

brew cask install font-inconsolata
brew cask install font-noto-sans-japanese
brew cask install font-source-code-pro

# Remove outdated versions from the cellar
brew cleanup
