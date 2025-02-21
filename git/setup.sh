#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

# Install GitHub CLI
brew install gh
gh completion -s zsh >$(brew --prefix)/share/zsh/site-functions/_gh

ln -fs "${DOTFILES_DIRECTORY}/git/gitattributes" "${HOME}/.gitattributes"
ln -fs "${DOTFILES_DIRECTORY}/git/gitignore" "${HOME}/.gitignore"
ln -fs "${DOTFILES_DIRECTORY}/git/gitconfig" "${HOME}/.gitconfig"

# Create .config/git directory if it doesn't exist
if [ ! -d "${HOME}/.config/git" ]; then
  mkdir -p "${HOME}/.config/git"
fi

ln -fs "${DOTFILES_DIRECTORY}/git/hooks" "${HOME}/.config/git/hooks"
chmod +x "${HOME}/.config/git/hooks/post-merge"

# Install diff-highlight
if [ ! -d "${HOME}/bin" ]; then
  mkdir ${HOME}/bin
fi
cp $(brew --prefix)/share/git-core/contrib/diff-highlight/diff-highlight ~/bin
