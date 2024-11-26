#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

mkdir -p ~/.config/alacritty/themes

ln -fs "${DOTFILES_DIRECTORY}/alacritty/alacritty.toml" "${HOME}/.config/alacritty/alacritty.toml"

git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
