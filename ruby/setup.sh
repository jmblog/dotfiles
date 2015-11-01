#!/usr/bin/env bash

# Install stable version's ruby using rbenv
if [[ ! "$(type -P rbenv)" ]]; then
  git clone https://github.com/sstephenson/rbenv.git ${HOME}/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build
else
  cd ${HOME}/.rbenv
  git pull
fi

# include rbenv init
source "${HOME}/.bashrc"

rbenv install 2.2.3
rbenv rehash
rbenv global 2.2.3

# Install ruby gems using bundler
if [[ ! "$(type -P gem)" ]]; then
  mkdir ${HOME}/.dotfiles/ruby/tmp
  cd ${HOME}/.dotfiles/ruby/tmp
  curl http://production.cf.rubygems.org/rubygems/rubygems-2.4.8.tgz > rubygems-2.4.8.tgz
  tar zxf rubygems-2.4.8.tgz
  cd rubygems-2.4.8/
  sudo ruby setup.rb
  rm -rf rubygems-2.4.8/
fi

gem install bundler
gem install middleman
gem install sass
gem install slim
