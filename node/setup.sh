#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"
source "${HOME}/.bashrc"
source ${DOTFILES_DIRECTORY}/lib/utils

# Install or update nvm
git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
. ~/.nvm/nvm.sh

# Install the stable version's node.js with nvm
nvm install stable
nvm use stable

# Install npm packages
npm update -g npm

npm install -g bower
npm install -g gulp
