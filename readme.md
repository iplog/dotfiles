# My Dotfiles

## Content

You can find a copy of my main dotfiles for:

- vim and macvim
- zsh
- oh-my-zsh
- git
- ssh

## Installation

Installation has been made easy. Just run :)

    $ git clone git@github.com:iplog/dotfiles ~/.dotfiles
    $ cd ~/.dotfiles
    $ ./brew_install.sh
    $ ./install.sh

You will be asked for some details in order to generate a custom version of the
.gitconfig file.

All your existing configuration files will be backuped with `.orig` extension. 

The installation has been tested on Mac (10.9) but should work on Linux.

If you only want to install vim:

- Open install.sh
- Remove the files you do not want from `confFiles` and `dests`
- Run

    $ ./install.sh

`vim/install.sh` should be run form the root folder (not form the `vim`
folder).

## Install Homebrew formulae

When setting up a new Mac, you may want to install some common Homebrew formulae (after installing [Homebrew](http://brew.sh/), of course):

    $ brew bundle ~/.dotfiles/Brewfile

## To do

Create an uninstallation script (For fun).
