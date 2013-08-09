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
    command "$HOME/.nodebrew/current/bin/nodebrew install #{version}"
    not_if "nodebrew list | grep #{version}"
  end
}

# Use <version>
execute "Use Node.js <version>" do
  command "nodebrew use " + node["nodejs"]["use"]
end

# Install Node packages
node["nodejs"]["packages"].each{|obj|
  execute "npm install #{obj.pkg}" do
    command "npm install #{obj.pkg} -g"
    not_if "type -P #{obj.cmd}"
  end 
}


# Git repos
#-------------------------------------------------------

node["gitrepos"].each{|obj|
  execute "Update git repository: #{obj.local}" do
    command "cd #{obj.local}; git pull; git submodule update --init --recursive --quiet"
    only_if do File.directory?(File.expand_path(obj.local)) end
  end
  
  execute "Clone git repository: #{obj.remote} #{obj.local}" do
    command "git clone --recursive #{obj.remote} #{obj.local}"
    not_if do File.directory?(File.expand_path(obj.local)) end
  end
}


# OS X Applications 
#-------------------------------------------------------

dmg_package "Google Chrome Canary" do
  dmg_name "googlechromecanary"
  source "https://storage.googleapis.com/chrome-canary/GoogleChromeCanary.dmg"
  action :install
end

dmg_package "ClamXav" do
  source "http://www.clamxav.com/downloads/ClamXav_2.3.6.dmg"
  checksum "4e59947bc049109c375613979fb6092ffe67aa55"
  action :install
end

