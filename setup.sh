#!/usr/bin/env bash

set -eu

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

# Logging functions with proper argument handling
function log_header() { echo -e "\n\x1B[4m$*\x1B[24m"; }
function log_info() { echo -e "\x1B[33m==> \x1B[39m$*"; }
function log_warn() { echo -e "\x1B[31m\x1B[4mWarning\x1B[24m\x1B[39m: $*"; }
function log_error() { echo -e "\x1B[31m\x1B[4mError\x1B[24m\x1B[39m: $*"; }
function log_ok() { echo -e "\x1B[32m==> \x1B[39m$*"; }
function log_success() { echo -e "\x1B[32m$*\x1B[39m"; }
function log_fail() { echo -e "\x1B[31m$*\x1B[39m"; }

# Function to run setup scripts
run_setup() {
  local script="$1"
  if [[ -f $script ]]; then
    bash "$script"
  else
    log_error "Setup script not found: $script"
  fi
}

# Check for command
check_command() {
  if command -v "$1" > /dev/null 2>&1; then
    log_ok "$1 is available"
  else
    log_error "Command not found: $1"
    exit 1
  fi
}
# Check dependencies
# ----------------------------------------------------------------------

# Install Homebrew if not present
log_header "Installing Homebrew..."
if ! command -v brew > /dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  log_info "Homebrew is already installed, checking for updates..."
  brew update
fi

# Preparation
# ----------------------------------------------------------------------

log_header "Installing git..."
if ! command -v git > /dev/null 2>&1; then
  brew install git
  log_ok "Git installed successfully"
else
  log_info "Git is already installed, checking for updates..."
  brew upgrade git
fi

# Check that the connection to the github server
log_header "Checking the connection to the github server..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  log_ok "GitHub connection successful"
else
  log_fail "Failed to authenticate with GitHub"
  log_fail "Please check your SSH key and GitHub account settings"
  exit 1
fi

# Clone repo
# ----------------------------------------------------------------------

log_header "Setting up dotfiles..."
if [[ ! -d ${DOTFILES_DIRECTORY} ]]; then
  git clone --recursive git@github.com:jmblog/dotfiles.git "${DOTFILES_DIRECTORY}"
  log_ok "Dotfiles repository cloned successfully"
else
  git -C "${DOTFILES_DIRECTORY}" pull origin main
  log_ok "Dotfiles repository updated successfully"
fi

cd "${DOTFILES_DIRECTORY}"

# Setup git
# ----------------------------------------------------------------------

log_header "Setting up git..."
run_setup "./git/setup.sh"

# Setup zsh
# ----------------------------------------------------------------------

log_header "Setting up zsh..."
run_setup "./zsh/setup.sh"

# Setup vim
# ----------------------------------------------------------------------

log_header "Setting up vim..."
run_setup "./vim/setup.sh"

# Setup Node.js
# ----------------------------------------------------------------------

log_header "Setting up Node.js..."
run_setup "./node/setup.sh"

# Install macOS packages
# ----------------------------------------------------------------------

log_header "Installing macOS packages..."
bash ./homebrew/brew.sh

# Install macOS apps
# ----------------------------------------------------------------------

read -p "Do you want to install macOS apps manually? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  bash ./applist.sh
fi

# Install fonts
# ----------------------------------------------------------------------

log_header "Installing fonts..."
read -p "Do you want to install fonts? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  bash ./homebrew/font.sh
fi

# Setup Alacritty
# ----------------------------------------------------------------------

log_header "Setting up Alacritty..."
run_setup "./alacritty/setup.sh"

# Setup WezTerm
# ----------------------------------------------------------------------

log_header "Setting up WezTerm..."
run_setup "./wezterm/setup.sh"

# Set macOS system defaults
# ----------------------------------------------------------------------

# log_header "Setting macOS system defaults..."
# bash ./macosdefaults.sh

# Create some directories
# ----------------------------------------------------------------------

log_header "Creating regular directories..."
mkdir -p ~/Projects ~/Sandbox

# Cleanup
# ----------------------------------------------------------------------

log_header "Cleaning up..."
brew cleanup

log_success "Dotfiles setup completed successfully!"
