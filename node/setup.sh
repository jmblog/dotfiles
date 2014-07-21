#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"
source "${HOME}/.bashrc"
source ${DOTFILES_DIRECTORY}/lib/utils


if ! use_boxen; then
  # Install stable version's node.js via nodebrew
  if [[ ! "$(type -P nodebrew)" ]]; then
    curl -L git.io/nodebrew | perl - setup
    source "${HOME}/.bashrc"
  else
    nodebrew selfupdate
  fi

  nodebrew install-binary stable
  nodebrew use stable
fi

# Install npm packages
npm update -g npm

npm install -g yo
npm install -g grunt-cli
npm install -g bower
npm install -g jshint
npm install -g uglifyjs
npm install -g gulp

