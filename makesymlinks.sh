#!/bin/bash
############################
# .make.sh This script creates symlinks from the home directory to any desired
# dotfiles in ~/dotfiles
############################

DOTFILES=dotfiles
dir=$HOME/$DOTFILES                    # dotfiles directory
datetag=$(date +%Y%m%d-%H%M%S)         # appended to backup files.
BACKUPDIR=$HOME/${DOTFILES}-$datetag   # backup directory for dotfiles

# Uncomment the DEBUG line for debugging
#DEBUG=echo

if ! hash realpath 2>/dev/null ; then
	echo "Required program not found (realpath), exiting."
	exit
fi

# list of files/folders to symlink in homedir
files="bashrc bash.d vimrc vim screenrc screenrc-ide \
       tmux.conf tmux.d Xresources.d Xresources ctags \
       terminfo gitignore_global gitconfig \
       fonts/Inconsolata-powerline"

# create dotfiles backup directory
if [ ! -d "$BACKUPDIR" ]; then
	echo -n "Creating $BACKUPDIR for backup... "
	$DEBUG mkdir -p $BACKUPDIR
	echo "done."
fi

# change to the dotfiles directory
echo -n "Changing to the $dir directory... "
cd "$dir"
echo "done."

# move any existing dotfiles in homedir to dotfiles_old directory, then create
# symlinks from the homedir to any files in the ~/dotfiles directory specified
# in $files
for file in $files; do

	# If the dotfile exists, and it's a regular file, then move it to
	# $BACKUPDIR for backup.
	if [ -f "$HOME/.$file" ] && [ ! -h "$HOME/.$file" ]; then
		echo "Moving existing ~/.$file to $BACKUPDIR"
		$DEBUG mv "$HOME/.$file" "$BACKUPDIR/$file"

	# If the destination is a directory, and not a symbolic link, then move it
	# to $BACKU{DIR for backup.
	elif [ -d "$HOME/.$file" ] && [ ! -h "$HOME/.$file" ]; then
		#$DEBUG rsync --remove-source-files -av $HOME/.fonts/Inconsolata-powerline $BACKUPDIR/fonts
		#$DEBUG rm -rf $HOME/.fonts/Inconsolata-powerline
		echo "Backing up ~/.$file to $BACKUPDIR"
		$DEBUG mkdir -p $BACKUPDIR/$file
		$DEBUG rsync --remove-source-files -a $HOME/.$file/ $BACKUPDIR/$file/
		$DEBUG rm -rf $HOME/.$file

	# If the dotfile exists as a symbolic link, and it doesn't point
	# to the correct file, then move it to $BACKUPDIR for backup.
	elif [ -h "$HOME/.$file" ] && [ "$(realpath $HOME/.$file)" != "$(realpath $dir/$file)" ]; then
		echo "Backing up ~/.$file to ${BACKUPDIR}/$file"
		$DEBUG mv "$HOME/.$file" "$BACKUPDIR/$file"
	fi

	if [ ! -e "$HOME/.$file" ]; then
		echo -n "Creating symlink: "
		OFILE=$(realpath $file)
		LFILE=$HOME/$(dirname $file)

		# Unfortunately, the cleanest way to determine relative paths
		# is to use perl.
		relpath=$(perl -e 'use File::Spec; print File::Spec->abs2rel(@ARGV) . "\n"' "$OFILE" "$LFILE")
		$DEBUG ln -sv "$relpath" "$HOME/.$file"
	fi
done

# Create default Xresouces current-scheme file.
if [ ! -e ~/.Xresources.d/current-scheme ] && [ -z $DEBUG ]; then
	echo "#define SOLARIZED_LIGHT" > ~/.Xresources.d/current-scheme
fi

# Create default tmux current-scheme file.
if [ ! -e ~/.tmux.d/current-scheme ] && [ -z $DEBUG ]; then
	echo "source-file ~/.tmux.d/solarized-light" > ~/.tmux.d/current-scheme
fi

# Update to color palette.
if [ -n "$DISPLAY" ]; then
	# Only run xrdb if in X.
	$DEBUG xrdb ~/.Xresources
fi

# Check if backup directory is empty.
ls -1qA "$BACKUPDIR" | grep -q .
if [ $? -eq 1 ]; then
	echo -n "Backup directory empty, deleting it..."
	rm -rf "$BACKUPDIR"
	echo " done."
fi

echo "Setup complete."
