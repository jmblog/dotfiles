# Dotfiles

My OS X dotfiles.

## How to install

```bash
$ bash -c "$(curl -fsSL raw.github.com/jmblog/dotfiles/master/bin/bootstrap)"
```

Note:

* You need to have installed the [XCode Command Line Tools](https://developer.apple.com/downloads).

* Existing dotfiles in your HOME and `.vim` directories may be overwritten.

## How to update

```bash
$ ~/.dotfiles/bin/bootstrap
```

You should run the update when:

* You want to update Homebrew formulae, Ruby gems and Node packages.
* You want to pull changes from the remote repository.
* You make a change to `~/.dotfiles/git/gitconfig` (the only file that is copied rather than symlinked).

## Features

### ✈ Mirror dotfiles

Some dotfiles are symlinked, and some are copied. See `links` and `copies` attributes in [chef-repo/nodes/localhost.json](https://github.com/jmblog/dotfiles/blob/master/chef-repo/nodes/localhost.json). 

### ✈ Install and update Homebrew packages

The homebrew packages that will be installed and updated are listed in `brew -> packages` attribute in [chef-repo/nodes/localhost.json](https://github.com/jmblog/dotfiles/blob/master/chef-repo/nodes/localhost.json).

### ✈ Install the specific version's Ruby

The list of versions is defined in [bin/bootstrap](https://github.com/jmblog/dotfiles/blob/master/bin/bootstrap).

### ✈ Install and update Ruby gems

See [Gemfile](https://github.com/jmblog/dotfiles/blob/master/Gemfile).

### ✈ Install the specific version's Node.js

The list of versions is defined in `nodejs -> versions` and `nodejs -> use` attributes in [chef-repo/nodes/localhost.json](https://github.com/jmblog/dotfiles/blob/master/chef-repo/nodes/localhost.json)

### ✈ Install and update Node.js packages (globally)

The Node.js packages that will be installed and update are listed in `nodejs -> pakcages` attribute in [chef-repo/nodes/localhost.json](https://github.com/jmblog/dotfiles/blob/master/chef-repo/nodes/localhost.json).

### ✈ Install OS X applications

The installed apps are listed in [chef-repo/site-cookbooks/dotfiles/recipes/default.rb](https://github.com/jmblog/dotfiles/blob/master/chef-repo/site-cookbooks/dotfiles/recipes/default.rb).

### ✈ Set Custom OS X defaults

Custom OS X settings can be applied by running the following command:

```bash
$ ~/.dotfiles/bin/osxdefaults
```

## Custom bash prompt

I use a custom bash prompt by @necolas. (I use @chriskempson's [Tomorrow Theme](https://github.com/chriskempson/tomorrow-theme) rather than Solarized.)

![Screenshot](http://farm3.staticflickr.com/2881/8975352568_0d291cb886_o.png)

## Thanks to

Inspriration and code was taken from:

* @necolas (Nicolas Gallagher) https://github.com/necolas/dotfiles
* @cowboy (Ben Alman) https://github.com/cowboy/dotfiles
* @mathiasbynens (Mathias Bynens) https://github.com/mathiasbynens/dotfiles
