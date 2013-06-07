#
# Cookbook Name:: dotfiles
# Recipe:: default
#
# Copyright 2013, Yoshihide Jimbo
#

# Mirror dotfiles
#-------------------------------------------------------

home_dir = ENV['HOME']
dotfiles_dir = File.expand_path(File.dirname(__FILE__) + '../../../../..')

node["copies"].each{|source, dest|
  from = dotfiles_dir + '/' + source
  to   = home_dir + '/' + dest
  execute "copy #{source} to #{dest}" do
    command "cp -rf #{from} #{to}"
    only_if {File.exists?(from)}
  end
}
 
node["links"].each{|source, dest|
  link dest do
    target_file home_dir + '/' + dest
    to          dotfiles_dir + '/' + source
  end
}

execute "source ~/.bash_profile" do
  command "source ~/.bash_profile"
end


# Homebrew packages
#-------------------------------------------------------

# Install and update packages
node["brew"]["packages"].each{|pkg|
  package pkg do
    action :install
  end
}

# Remove outdated versions from the Cellar
execute "Remove outdated versions from the Cellar" do
  command "brew cleanup"
end


# Node.js
#-------------------------------------------------------

# Install nodebrew if missing
execute "Install nodebrew" do
  command "curl -L git.io/nodebrew | perl - setup"
  not_if "type -P nodebrew"
end

# Update nodebrew
execute "Update nodebrew" do
  command "nodebrew selfupdate"
  only_if "type -P nodebrew"
end

# Install Node.js
node["nodejs"]["versions"].each{|version|
  execute "Install Node.js #{version}" do
    command "nodebrew install #{version}"
    not_if "nodebrew list | grep #{version}"
  end
}

# Use <version>
execute "Use Node.js <version>" do
  command "nodebrew use " + node["nodejs"]["use"]
end

# Install Node packages
node["nodejs"]["packages"].each{|pkg, cmd|
  execute "npm install #{pkg}" do
    command "npm install #{pkg} -g"
    not_if "type -P #{cmd}"
  end 
}


# OS X Applications 
#-------------------------------------------------------

dmg_package "Google Chrome" do
  dmg_name "googlechrome"
  source "https://dl-ssl.google.com/chrome/mac/stable/GGRM/googlechrome.dmg"
  checksum "7daa2dc5c46d9bfb14f1d7ff4b33884325e5e63e694810adc58f14795165c91a"
  action :install
end

dmg_package "Google Chrome Canary" do
  dmg_name "googlechromecanary"
  source "https://storage.googleapis.com/chrome-canary/GoogleChromeCanary.dmg"
  action :install
end

dmg_package "TotalFinder" do
  source "http://downloads.binaryage.com/TotalFinder-1.4.9.dmg"
  action :install
end

dmg_package "Dropbox" do
  volumes_dir "Dropbox Installer"
  source "http://www.dropbox.com/download?plat=mac"
  checksum "b4ea620ca22b0517b75753283ceb82326aca8bc3c86212fbf725de6446a96a13"
  action :install
end

dmg_package "ClamXav" do
  source "http://www.clamxav.com/downloads/ClamXav_2.3.6.dmg"
  checksum "4e59947bc049109c375613979fb6092ffe67aa55"
  action :install
end

