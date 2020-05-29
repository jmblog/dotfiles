#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

# It is expected that git is already installed
brew install hub

ln -fs "${DOTFILES_DIRECTORY}/git/gitattributes" "${HOME}/.gitattributes"
ln -fs "${DOTFILES_DIRECTORY}/git/gitignore" "${HOME}/.gitignore"
ln -fs "${DOTFILES_DIRECTORY}/git/gitconfig" "${HOME}/.gitconfig"

# Install diff-highlight
mkdir ${HOME}/bin
cp /usr/local/share/git-core/contrib/diff-highlight/diff-highlight ~/bin
