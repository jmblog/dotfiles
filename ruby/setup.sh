#!/usr/bin/env bash

# Install stable version's ruby using rbenv
if [[ ! "$(type -P rbenv)" ]]; then
  git clone https://github.com/sstephenson/rbenv.git ${HOME}/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build
fi

# include rbenv init
source "${HOME}/.bashrc"

rbenv install 2.1.1
rbenv rehash

# Install ruby gems using bundler
if [[ ! "$(type -P gem)" ]]; then
  mkdir ${HOME}/.dotfiles/ruby/tmp
  cd ${HOME}/.dotfiles/ruby/tmp
  curl http://production.cf.rubygems.org/rubygems/rubygems-2.2.2.tgz > rubygems-2.2.2.tgz
  tar zxf rubygems-2.2.2.tgz
  cd rubygems-2.2.2/
  sudo ruby setup.rb
fi

gem install bundler
gem install compass
gem install middleman
gem install middleman-livereload
gem install middleman-slim
gem install sass
gem install slim
