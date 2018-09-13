#!/usr/bin/env bash

brew install rbenv ruby-build

# include rbenv init
rbenv install 2.5.1
rbenv rehash
rbenv global 2.5.1
eval "$(rbenv init -)"

gem install bundler
rbenv rehash
