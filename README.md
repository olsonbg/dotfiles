dotfiles
=====

# Index
* [Installation](#installation)
* [Upgrading](#upgrading)
* [Usage](#usage)
 * [Using solarized color scheme](#solarized-scheme)
 * [Host specific settings](#host-specific-settings)
 * [Font (Inconsolata)](#font)
 * [rxvt-unicode terminal](#rxvt-unicode)
* [Caveats](#caveats)
 * [Tmux](#tmux)
 * [Multiple Terminals Open](#multiple-terminals-open)
 * [KDE](#kde)

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
Current dotfiles are backed up to the ~/dotfiles_old directory, with the current date-time added to the end of the filename(s).
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

## Upgrade each bundled plugin

```bash
$ git submodule foreach git pull origin master
```

# Usage
## Solarized scheme
When first installed, the light [solarized](https://github.com/altercation/solarized) color scheme is used. The light or dark color schemes can be selected by using the `solarized-light` or `solarized-dark` commands, respectively. The command `solarized` will toggle between solarized-dark and solarize-light schemes. The new color scheme will take effect immediately, with a few [caveats](#caveats).

The `solarized` command writes a single line to the .Xresources.d/current-scheme file, either
```bash
#define SOLARIZED_LIGHT
```
or
```bash
#define SOLARIZED_DARK
```

This file is loaded first in the .Xresources file, followed by a series of `#ifdef` statements which load the correct solarized scheme.
### Solarized color schemes included
* Vim
* Tmux
* ls (dircolors)
* Any program which makes use of xrdb resources (most terminals)

## Host Specific Settings
Settings for specific hosts can be placed in `bash.d/hosts/<hostname>`, where `<hostname>` is the hostname of the machine as returned from the command `hostname`. If there is no matching folder for a host, then the settings in `bash.d/hosts/generic` will be used.

## Font
The [Inconsolata](https://www.google.com/fonts/specimen/Inconsolata) font is used in [xterm](http://invisible-island.net/xterm/), and [rxvt-unicode](http://software.schmorp.de/pkg/rxvt-unicode.html). The font is not included with this repository, so it will need to be installed.

## rxvt-unicode
As mentioned [previously](#font), the Inconsolata font is used in rxvt-unicode. The default font size is 11, however, the font size of a currently open terminal can be changed with one of the following:


| Key Sequence | Font size |
| :------------|:---------:|
| Control-8    | 9         |
| Control-9    | 10        |
| Control-0    | 11        |

# Caveats

## Tmux
To enable the new color scheme in a currently running tmux session follow these steps:
  1. Detatch from tmux,
  2. Change the color scheme, with one of the previously listed commands,
  3. reattach to the tmux session.

## Multiple terminals open
When changing the solarized scheme in a terminal, the new scheme will take effect immediately in that terminal, but not in others that are currently running. To activate the new colors in other terminals, use either the `solarized-light` or `solarized-dark` command in each open terminal.

## KDE
To load the Xresources file on KDE login, this small script needs to be placed in the KDE Autostart directory (~/.kde4/Autostart).
```bash
#!/bin/sh

xrdb ~/.Xresources
```
This script is needed for KDE because it does not process an Xresources file containing #include directives properly (relative paths don't work). As far as I know, KDE is the only desktop that needs this _fix_.
