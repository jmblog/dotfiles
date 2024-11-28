#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"
WEZTERM_CONFIG_DIRECTORY="${HOME}/.config/wezterm"

if [ ! -d "$WEZTERM_CONFIG_DIRECTORY" ]; then
  mkdir -p $WEZTERM_CONFIG_DIRECTORY
fi

brew install wezterm

ln -fs "${DOTFILES_DIRECTORY}/wezterm/wezterm.lua" "${WEZTERM_CONFIG_DIRECTORY}/wezterm.lua"
