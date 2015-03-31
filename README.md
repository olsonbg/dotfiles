dotvim
=====


## Installation

```
git clone git://github.com/olsonbg/dotfiles.git ~/dotfiles
```

## Update submodules

```
cd ~/dotfile
git submodule init
git submodule update
```

## Create symlinks

```
Run the script: ~/dotfiles/makesymlinks.sh
```

## To upgrage each bundled plugin

```
git submodule foreach git pull origin master
```
