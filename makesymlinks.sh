#!/bin/bash
############################
# .make.sh This script creates symlinks from the home directory to any desired
# dotfiles in ~/dotfiles
############################

DOTFILES=dotfiles
DOTFILES_BACKUP=${DOTFILES}_old
dir=$HOME/$DOTFILES                      # dotfiles directory
olddir=$HOME/${DOTFILES_BACKUP}          # old dotfiles backup directory
datetag=$(date +%Y-%m-%d-%H%M%S)         # appended to backup files.

# list of files/folders to symlink in homedir
files="bashrc bash.d vimrc vim screenrc screenrc-ide \
       tmux.conf Xresources.d Xresources"

# create dotfiles_old in homedir
if [ ! -d "$olddir" ]; then
	echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
	mkdir -p $olddir
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
	# Some of the dotfiles in $files may by symbolic links, therefore need to
	# get the canonicalized file name for linking to the users home directory.
	CANON_FILE=$(readlink -f $file | sed -e s:^$dir/::)

	# If the dotfile exists, and it's a regular file, then move it to
	# $olddir for backup.
	if [ -f "$HOME/.$file" ] && [ ! -h "$HOME/.$file" ]; then
		echo "Moving existing ~/.$file from ~ to $olddir"
		mv "$HOME/.$file" "$olddir/$file-$datetag"

	# If the dotfile exists as a symbolic link, and it doesn't point
	# to the correct file, then move it to $olddir for backup.
	elif [ -h "$HOME/.$file" ] && [ "$(readlink $HOME/.$file)" != "$DOTFILES/$CANON_FILE" ]; then
		echo "Backing up ~/.$file to ${DOTFILES_BACKUP}/$file-$datetag"
		mv "$HOME/.$file" "$olddir/$file-$datetag"
	fi

	if [ ! -e "$HOME/.$file" ]; then
		echo -n "Creating symlink: "
		ln -sv "$DOTFILES/$CANON_FILE" "$HOME/.$file"
	fi
done

echo "Setup complete."
