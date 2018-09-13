#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

# It is expected that git is already installed
brew install hub

ln -fs "${DOTFILES_DIRECTORY}/git/gitattributes" "${HOME}/.gitattributes"
ln -fs "${DOTFILES_DIRECTORY}/git/gitignore" "${HOME}/.gitignore"
ln -fs "${DOTFILES_DIRECTORY}/git/gitconfig" "${HOME}/.gitconfig"

# Install diff-highlight
mkdir ${HOME}/bin
curl https://raw.githubusercontent.com/git/git/master/contrib/diff-highlight/diff-highlight > ~/bin/diff-highlight && chmod +x ~/bin/diff-highlight

# Install completions
# https://blog.qnyp.com/2013/05/14/zsh-git-completion/
mkdir -p ~/.zsh/completion
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.zsh/completion/git-completion.bash
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh > ~/.zsh/completion/_git
curl https://raw.githubusercontent.com/github/hub/master/etc/hub.zsh_completion > ~/.zsh/completion/_hub
