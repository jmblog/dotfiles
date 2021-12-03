#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

brew install zsh-completions zsh-autosuggestions

# Install `sindresorhus/pure` prompt
curl https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh > "${HOME}/.dotfiles/zsh/pure/pure.zsh"
curl https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh > "${HOME}/.dotfiles/zsh/pure/async.zsh"
ln -s "${HOME}/.dotfiles/zsh/pure/pure.zsh" /usr/local/share/zsh/site-functions/prompt_pure_setup
ln -s "${HOME}/.dotfiles/zsh/pure/async.zsh" /usr/local/share/zsh/site-functions/async

# Mirror dotfiles
ln -fs "${DOTFILES_DIRECTORY}/zsh/zshrc" "${HOME}/.zshrc"

# Compile .zshrc
zcompile ~/.zshrc
