# Dotfiles

My dotfiles

## Installation

```bash
$ bash -c "$(curl -fsSL raw.github.com/jmblog/dotfiles/master/bin/dotfiles)" && source ~/.bashrc
```

### Notes
* Existing dotfiles in your HOME and `.vim` directories may be overwritten.

#### For OS X

* You need to have installed the XCode Command Line Tools. Run `xcode-select --install` to install them.

## Updating

Run the `dotfiles` command.

```bash
$ dotfiles
```

You should run the update when:

* You make a change to `~/.dotfiles/git/gitconfig` (the only file that is copied rather than symlinked).
* You want to pull changes from the remote repository.
* You want to update Homebrew formulae, Ruby gems and Node packages.

### Install Homebrew formulae


```bash
$ brew bundle ~/.dotfiles/osx/homebrew/Brewfile
```

### Install OS X native applications with `brew cask`


```bash
$ brew bundle ~/.dotfiles/osx/homebrew/Caskfile
```

Applications will be installed in `/usr/local/Caskroom` and symlinked to `/Applications`. Check `$HOMEBREW_CASK_OPTS` in `.bash_exports`.

### Set Custom OS X defaults

```bash
$ osxdefaults
```

## Custom bash prompt

I use a custom bash prompt by [@necolas](https://github.com/necolas) and [Tomorrow Night Bright Theme](https://github.com/chriskempson/tomorrow-theme) by [@chriskempson](https://github.com/chriskempson).

![Screenshot](http://farm3.staticflickr.com/2881/8975352568_0d291cb886_o.png)

## Thanks to

Inspriration and code was taken from:

* @necolas (Nicolas Gallagher) https://github.com/necolas/dotfiles
* @cowboy (Ben Alman) https://github.com/cowboy/dotfiles
* @mathiasbynens (Mathias Bynens) https://github.com/mathiasbynens/dotfiles
