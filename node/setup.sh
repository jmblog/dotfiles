#!/usr/bin/env bash
DOTFILES_DIRECTORY="${HOME}/.dotfiles"
source "${HOME}/.bashrc"
source ${DOTFILES_DIRECTORY}/lib/utils

# Install or update nvm
if [[ ! -d "${HOME}/.nvm" ]]; then
  git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
else
  cd "${HOME}/.nvm"
  git fetch -p
  git checkout `git describe --abbrev=0 --tags`
fi

source "${HOME}/.nvm/nvm.sh"

# Install the stable version's node.js with nvm
echo "${USER}"
nvm install stable
nvm use stable
nvm alias default node

# Install npm packages
npm update -g npm

npm install -g bower
npm install -g gulp
