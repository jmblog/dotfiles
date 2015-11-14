#!/usr/bin/env bash

if [[ ! "$(type -P pip)" ]]; then
  sudo easy_install pip
fi

if [[ ! "$(type -P pygmentize)" ]]; then
  sudo pip install Pygments
fi
