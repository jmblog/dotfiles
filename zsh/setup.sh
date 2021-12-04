#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

brew install zsh-completions zsh-autosuggestions

# Install `sindresorhus/pure` prompt
npm install --global pure-prompt

# Mirror dotfiles
ln -fs "${DOTFILES_DIRECTORY}/zsh/zshrc" "${HOME}/.zshrc"

# Compile .zshrc
zcompile ~/.zshrc
