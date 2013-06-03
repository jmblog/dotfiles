#
# Cookbook Name:: dotfiles
# Recipe:: brew
#
# Copyright 2013, Yoshihide Jimbo
#
# All rights reserved - Do Not Redistribute
#
node["brew"]["packages"].each{|pkg|
  package pkg do
    action :install
  end

  homebrew_package pkg
}
