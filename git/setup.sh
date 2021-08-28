#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

# Install GitHub CLI
brew install gh
gh completion -s zsh > /usr/local/share/zsh/site-functions/_gh


ln -fs "${DOTFILES_DIRECTORY}/git/gitattributes" "${HOME}/.gitattributes"
ln -fs "${DOTFILES_DIRECTORY}/git/gitignore" "${HOME}/.gitignore"
ln -fs "${DOTFILES_DIRECTORY}/git/gitconfig" "${HOME}/.gitconfig"

# Install diff-highlight
mkdir ${HOME}/bin
cp /usr/local/share/git-core/contrib/diff-highlight/diff-highlight ~/bin
