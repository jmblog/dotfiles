#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"
GHOSSTY_CONFIG_DIRECTORY="${HOME}/.config/ghostty"

if [ ! -d "$GHOSSTY_CONFIG_DIRECTORY" ]; then
  mkdir -p "$GHOSSTY_CONFIG_DIRECTORY"
fi

brew install --cask ghostty

ln -fs "${DOTFILES_DIRECTORY}/ghostty/config" "${GHOSSTY_CONFIG_DIRECTORY}/config"
