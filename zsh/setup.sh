#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

brew install zsh-completions zsh-autosuggestions

# Install `sindresorhus/pure` prompt
brew install pure

# Mirror dotfiles
ln -fs "${DOTFILES_DIRECTORY}/zsh/.zshrc" "${HOME}/.zshrc"
