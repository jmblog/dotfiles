# Dotfiles

My OS X dotfiles.

## How to install

The installation step requires the [XCode Command Line Tools](https://developer.apple.com/downloads) and may overwrite existing dotfiles in your HOME and `.vim` directories.

```bash
$ bash -c "$(curl -fsSL raw.github.com/jmblog/dotfiles/master/bin/dotfiles)"
```

## How to update

You should run the update when:

* You make a change to `~/.dotfiles/git/gitconfig` (the only file that is
  copied rather than symlinked).
* You want to pull changes from the remote repository.
* You want to update Homebrew formulae and Node packages.

Run the dotfiles command:

```bash
$ dotfiles
```

Options:

<table>
    <tr>
        <td><code>-h</code>, <code>--help</code></td>
        <td>Help</td>
    </tr>
    <tr>
        <td><code>-l</code>, <code>--list</code></td>
        <td>List of additional applications to install</td>
    </tr>
    <tr>
        <td><code>--no-packages</code></td>
        <td>Suppress package updates</td>
    </tr>
    <tr>
        <td><code>--no-sync</code></td>
        <td>Suppress pulling from the remote repository</td>
    </tr>
</table>


## Features

### Automatic software installation

#### Homebrew formulae

#### Node and Node packages

#### Ruby and Ruby Gems




### Custom OS X defaults

Custom OS X settings can be applied during the `dotfiles` process. They can
also be applied independently by running the following command:

```bash
$ osxdefaults
```

### Bootable backup-drive script

These dotfiles include a script that will incrementally back up your data to an
external, bootable clone of your computer's internal drive. First, make sure
that the value of `DST` in the `bin/backup` script matches the name of your
backup-drive. Then run the following command:

```bash
$ backup
```

For more information on how to setup your backup-drive, please read the
preparatory steps in this post on creating a [Mac OS X bootable backup
drive](http://nicolasgallagher.com/mac-osx-bootable-backup-drive-with-rsync/).

### Custom bash prompt


## Structure

## Acknowledgements

Inspriration and code was taken from:

* @necolas (Nicolas Gallagher) https://github.com/necolas/dotfiles
* @cowboy (Ben Alman) https://github.com/cowboy/dotfiles
