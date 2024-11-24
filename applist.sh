#!/usr/bin/env bash

# Function to prompt and open URL
prompt_and_open() {
  local app_name="$1"
  local url="$2"

  echo -e "\n${app_name}"
  read -p "Would you like to open download page for ${app_name}? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "$url"
  fi
}

# Download from the official websites
# ----------------------------------------------------------------------

prompt_and_open "Google Chrome" https://www.google.com/chrome/

prompt_and_open 1Password https://1password.com/jp/downloads/mac

prompt_and_open Alacritty https://alacritty.org/

prompt_and_open AppCleaner https://freemacsoft.net/appcleaner/

prompt_and_open Discord https://discord.com/download

prompt_and_open Dropbox https://www.dropbox.com/ja/desktop

prompt_and_open Figma https://www.figma.com/ja-jp/downloads/

prompt_and_open "Firefly IOTA" https://firefly.iota.org/

prompt_and_open "Google Japanese Input" https://www.google.co.jp/ime/

prompt_and_open Squoosh https://squoosh.app/

prompt_and_open Kap https://getkap.co/

prompt_and_open "Karabiner Elements" https://karabiner-elements.pqrs.org/

prompt_and_open Notion https://www.notion.com/desktop

prompt_and_open PopClip https://www.popclip.app/

prompt_and_open Slack https://slack.com/intl/en-gb/downloads/mac

prompt_and_open Sync https://www.sync.com/install/

prompt_and_open "Visual Studio Code" https://code.visualstudio.com/download

prompt_and_open "Zoom" https://zoom.us/download

# Get these apps from App Store
#
# Battery Indicator
# CotEditor
# Dato
# Hidden Bar
# Kindle
# Keynote
# LINE
# Unsplash Wallpapers
# PopClip
# Velja
# ----------------------------------------------------------------------
open -a "App Store"
