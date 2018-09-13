#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

brew install zsh zsh-completions zsh-autosuggestions

# Make zsh a default shell
#    1. Add $binroot/zsh into /etc/shells
#    2. Run `chsh -s $binroot/zsh`

binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin
if [[ "$(type -P $binroot/zsh)" && "$(cat /etc/shells | grep -q "$binroot/zsh")" ]]; then
  log_subhead "Adding $binroot/zsh to the list of acceptable shells"
  echo "$binroot/zsh" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$SHELL" != "$binroot/zsh" ]]; then
  log_subhead "Making $binroot/zsh a default shell"
  sudo chsh -s "$binroot/zsh" "$USER" >/dev/null 2>&1
fi

# Install `sindresorhus/pure` prompt
curl https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh > "${HOME}/.dotfiles/zsh/pure/pure.zsh"
curl https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh > "${HOME}/.dotfiles/zsh/pure/async.zsh"
ln -s "${HOME}/.dotfiles/zsh/pure/pure.zsh" /usr/local/share/zsh/site-functions/prompt_pure_setup
ln -s "${HOME}/.dotfiles/zsh/pure/async.zsh" /usr/local/share/zsh/site-functions/async

# Mirror dotfiles
ln -fs "${DOTFILES_DIRECTORY}/zsh/zshrc" "${HOME}/.zshrc"

# Compile .zshrc
zcompile ~/.zshrc
