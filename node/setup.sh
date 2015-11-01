#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"
source "${HOME}/.bashrc"
source ${DOTFILES_DIRECTORY}/lib/utils

# Install or update nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash

# Install the stable version's node.js with nvm
nvm install stable
nvm use stable

# Install npm packages
npm update -g npm

npm install -g bower
npm install -g gulp
