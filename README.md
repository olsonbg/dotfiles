dotfiles
=====

# Index
* [Installation](#installation)
* [Upgrading](#upgrading)
* [Usage](#usage)
 * [Using solarized theme](#solarized-scheme)
 * [Host specific settings](#host-specific-settings)
 * [Font (Inconsolata)](#font)

# Installation

## Clone the repository
```bash
$ git clone git://github.com/olsonbg/dotfiles.git ~/dotfiles
```

## Get the submodules

```bash
$ cd ~/dotfiles
$ git submodule init
$ git submodule update
```

## Create symlinks
Current dotfiles are backed up to the ~/dotfiles_old directorory, with the current date-time added to the end of the filename(s).
```bash
$ ~/dotfiles/makesymlinks.sh
```

To activate the new settings, it's easiest to open a new terminal. Methods to activate the new settings in a currently running terminal vary, but one of the following commands may work
```
. ~/.bash_profile
. ~/.bashrc
```

# Upgrading

## Get the latest version
```bash
$ cd ~/dotfiles
$ git pull
```

## Upgrage each bundled plugin

```bash
$ git submodule foreach git pull origin master
```

# Usage
## Solarized scheme
When first installed, the dark [solarized](https://github.com/altercation/solarized) color scheme is used. The light or dark color schemes can be selected by using the `solarized-light` and `solarized-dark` commands, respectively. The command `solarized` will toggle between solarized-dark and solarize-light schemes. The new color scheme will take effect immediately, with a few caveats:

* To enable the new color scheme in a currently running tmux session follow these steps:
  1. Detatch from tmux,
  2. Change the color scheme, with one of the previously listed commands,
  3. reattach to the tmux session.
* When already running vim. (TODO)

## Host Specific Settings
Settings for specific hosts can be placed in `bash.d/hosts/<hostname>`, where `<hostname>` is the hostname of the machine as returned from the command `hostname`. If there is no matching folder for a host, then the settings in `bash.d/hosts/generic` will be used.

## Font
The [Inconsolata](https://www.google.com/fonts/specimen/Inconsolata) font is used in [xterm](http://invisible-island.net/xterm/), and [rxvt-unicode](http://software.schmorp.de/pkg/rxvt-unicode.html). The font is not included with this repository, so it will need to be installed.
