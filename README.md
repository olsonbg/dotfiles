dotfiles
=====


## Installation

```bash
$ git clone git://github.com/olsonbg/dotfiles.git ~/dotfiles
```

## Update submodules

```bash
$ cd ~/dotfile
$ git submodule init
$ git submodule update
```

## Create symlinks

```bash
$ ~/dotfiles/makesymlinks.sh
```

## To upgrage each bundled plugin

```bash
$ git submodule foreach git pull origin master
```
