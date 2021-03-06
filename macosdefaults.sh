#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `osxdefaults` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# General UI/UX
# ----------------------------------------------------------------------

# Set computer name (as done via System Preferences → Sharing)
#sudo scutil --set ComputerName "yoshihide-mba"
#sudo scutil --set HostName "yoshihide-mba"
#sudo scutil --set LocalHostName "yoshihide-mba"
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "yoshihide-mba"

# Menu bar: disable transparency
#defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable opening and closing window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false



# Trackpad, mouse, keyboard, Bluetooth accessories, and input
# ----------------------------------------------------------------------

# Trackpad: enable tap to click for this user and for the login screen
#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
#defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
#defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3


# Screen
# ----------------------------------------------------------------------
# Require password immediately after sleep or screen saver begins
#defaults write com.apple.screensaver askForPassword -int 1
#defaults write com.apple.screensaver askForPasswordDelay -int 0


# Finder
# ----------------------------------------------------------------------

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Make folder name localizations invalid
sudo rm -f /Applications/.localized
sudo rm -f /Applications/Utilities/.localized
sudo rm -f /Users/.localized
sudo rm -f /Users/Shared/.localized
sudo rm -f /Library/.localized
rm -f ~/Applications/.localized
rm -f ~/Desktop/.localized
rm -f ~/Documents/.localized
rm -f ~/Downloads/.localized
rm -f ~/Dropbox/.localized
rm -f ~/Library/.localized
rm -f ~/Movies/.localized
rm -f ~/Music/.localized
rm -f ~/Pictures/.localized
rm -f ~/Public/.localized
rm -f ~/Sites/.localized

# Dock, Dashboard, and hot corners
# ----------------------------------------------------------------------

# Dock: position the Dock on the bottom
#defaults write com.apple.dock orientation bottom

# Dock: set the icon size of Dock items
#defaults write com.apple.dock tilesize -int 36

# Set the icon large size of Dock items
#defaults write com.apple.dock largesize -float 63

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Top left screen corner → Mission Control
#defaults write com.apple.dock wvous-tl-corner -int 2
#defaults write com.apple.dock wvous-tl-modifier -int 0

# Top right screen corner →Nothing
#defaults write com.apple.dock wvous-tr-corner -int 0
#defaults write com.apple.dock wvous-tr-modifier -int 0

# Bottom right screen corner → Desktop
#defaults write com.apple.dock wvous-br-corner -int 4
#defaults write com.apple.dock wvous-br-modifier -int 0

# Bottom left screen corner →Show application windows
#defaults write com.apple.dock wvous-bl-corner -int 3
#defaults write com.apple.dock wvous-bl-modifier -int 0


# Safari & Webkit
# ----------------------------------------------------------------------

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true


# Misc
# ----------------------------------------------------------------------


# Kill affected applications
# ----------------------------------------------------------------------

for app in "Dashboard" "Dock" "Finder" "SystemUIServer"; do
  killall "$app" > /dev/null 2>&1
done
