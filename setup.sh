#!/usr/bin/env bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

# Logging stuff
function log_warn()    { echo -e "\x1B[31m\x1B[4mWarning\x1B[24m\x1B[39m: $@"; }
function log_error()   { echo -e "\x1B[31m\x1B[4mError\x1B[24m\x1B[39m: $@"; }
function log_ok()      { echo -e "\x1B[32m==> \x1B[39m$@"; }
function log_success() { echo -e "\x1B[32m$@\x1B[39m"; }
function log_fail()    { echo -e "\x1B[31m$@\x1B[39m"; }
function log_header()  { echo -e "\x1B[4m$@\x1B[24m"; }
function log_subhead() { echo -e "\x1B[1m$@\x1B[22m"; }
function log_info()    { echo -e "\x1B[33m==> \x1B[39m$@"; }

# Check dependencies
# ----------------------------------------------------------------------

# Check for homebrew
if [[ ! $(type -P brew) ]]; then
    log_header "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi


# Preparation
# ----------------------------------------------------------------------

brew install git

# Check that the connection to the github server
ssh -vT git@github.com >/dev/null 2>&1
if [ $? -ne 1 ]; then
    log_fail "git@github.com: Permission denied (publickey)."
    log_fail "Please generate a SSH key and associate it with GitHub."
    log_fail "See https://help.github.com/articles/error-permission-denied-publickey/ for more details."
    exit 1
fi

# Clone repo
# ----------------------------------------------------------------------

if [[ ! -d ${DOTFILES_DIRECTORY} ]]; then
    log_header "Downloading dotfiles..."
    git clone --recursive git@github.com:jmblog/dotfiles.git ${DOTFILES_DIRECTORY}
    cd ${DOTFILES_DIRECTORY}
fi

# Setup git
# ----------------------------------------------------------------------

log_header "Setting git..."
bash ./git/setup.sh

# Setup zsh
# ----------------------------------------------------------------------

log_header "Setting zsh..."
bash ./zsh/setup.sh

# Setup vim
# ----------------------------------------------------------------------

log_header "Setting vim..."
ln -fs "${DOTFILES_DIRECTORY}/vim/vimrc" "${HOME}/.vimrc"
ln -fs "${DOTFILES_DIRECTORY}/vim" "${HOME}/.vim"


# Setup node
# ----------------------------------------------------------------------

log_header "Installing the latest node..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install node
nvm use node

bash ./node/npm.sh

# Install macOS packages
# ----------------------------------------------------------------------

log_header "Installing macOS packages..."
bash ./homebrew/brew.sh

# Install macOS apps
# ----------------------------------------------------------------------

#log_header "Installing macOS apps..."
#bash ./homebrew/cask.sh
#log_info "Some apps should be installed manually..."
#bash ./applist.sh

# Install fonts
# ----------------------------------------------------------------------

log_header "Installing fonts..."
bash ./homebrew/font.sh
log_info "Download San Fransisco font from https://developer.apple.com/fonts/ manually."


# Setup item2
# http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/
# ----------------------------------------------------------------------

log_header "Setting iterm2..."
# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.dotfiles/iterm2"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# Set macOS system defaults
# ----------------------------------------------------------------------

# log_header "Setting macOS system defaults..."
# bash ./macosdefaults.sh


# Create some directories
# ----------------------------------------------------------------------

log_header "Create the regular directories..."
mkdir ~/Projects
mkdir ~/Sandbox

# Cleanup
# ----------------------------------------------------------------------

brew cleanup
