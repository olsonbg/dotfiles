#!/bin/bash
############################
# .make.sh This script creates symlinks from the home directory to any desired
# dotfiles in ~/dotfiles
############################

DOTFILES=dotfiles
dir=$HOME/$DOTFILES                    # dotfiles directory
olddir=$HOME/${DOTFILES}_old             # old dotfiles backup directory

# list of files/folders to symlink in homedir
files="bashrc bash.d vimrc vim Xresources screenrc"

# create dotfiles_old in homedir
if [ ! -d "$olddir" ]; then
	echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
#	mkdir -p $olddir
	echo "done"
fi

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd "$dir"
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create
# symlinks from the homedir to any files in the ~/dotfiles directory specified
# in $files
for file in $files; do
	
	# If the dotfile exists, and it's a regular file, then move it to
	# $olddir for backup.
	if [ -f "$HOME/.$file" ] && [ ! -h "$HOME/.$file" ]; then
		echo "Moving existing ~/.$file from ~ to $olddir"
		mv "$HOME/.$file" "$olddir/"
	# If the dotfile exists as a symbolic link, and it's doesn't point
	# to "$dir/$file" then move it to $olddir for backup.
	elif [ -h "$HOME/.$file" ] && [ "$(readlink $HOME/.$file)" != "$DOTFILES/$file" ]; then
		echo "Deleting existing ~/.$file symbolic link"
		rm "$HOME/.$file"
	fi

	if [ ! -e "$HOME/.$file" ]; then
		echo "Creating symlink to $file in home directory."
		ln -s $DOTFILES/$file $HOME/.$file
	fi
done

