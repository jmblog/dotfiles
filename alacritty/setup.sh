#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"
ALACRITTY_CONFIG_DIRECTORY="${HOME}/.config/alacritty"
ALACRITTY_THEMES_DIRECTORY="${ALACRITTY_CONFIG_DIRECTORY}/themes"

if [ ! -d "$ALACRITTY_CONFIG_DIRECTORY/themes" ]; then
  mkdir -p ~/.config/alacritty/themes
fi

ln -fs "${DOTFILES_DIRECTORY}/alacritty/alacritty.toml" "${ALACRITTY_CONFIG_DIRECTORY}/alacritty.toml"

if [[ ! -d ${ALACRITTY_THEMES_DIRECTORY} ]]; then
  git clone https://github.com/alacritty/alacritty-theme "${ALACRITTY_THEMES_DIRECTORY}"
else
  git -C "${ALACRITTY_THEMES_DIRECTORY}" pull origin master
fi

# https://github.com/alacritty/alacritty/issues/4673#issuecomment-771291615
spctl --add /Applications/Alacritty.app
