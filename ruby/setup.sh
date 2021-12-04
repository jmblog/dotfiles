#!/usr/bin/env bash

brew install rbenv
rbenv init
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash

rbenv install 3.0.3
