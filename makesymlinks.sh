#!/bin/bash
#
# This script creates symlinks from the home directory to the dotfiles.
# Existing dotfiles are moved to the $HOME/dotfiles-<datetime> directory.
#

# The directory where this script is located and all the dotfiles
# should be linked to.
dotdir=$(dirname "$(readlink -f "$0")")

datetag=$(date +%Y%m%d-%H%M%S)      # appended to backup files.
BACKUPDIR=$HOME/dotfiles-$datetag   # backup directory for dotfiles


# Uncomment the DEBUG line for debugging
#DEBUG=echo

if ! hash realpath 2>/dev/null ; then
	echo "Required program not found (realpath), exiting."
	exit
fi

echo "Dotfiles are stored in $dotdir."

# list of files/folders to symlink in homedir
files="bashrc bash.d vimrc vim screenrc screenrc-ide \
       tmux.conf tmux.d Xresources.d Xresources ctags \
       terminfo gitignore_global gitconfig \
       fonts/Inconsolata-powerline \
       config/openbox/lxde-rc.xml"

# create dotfiles backup directory
if [ ! -d "$BACKUPDIR" ]; then
	echo -n "Creating $BACKUPDIR for backup... "
	$DEBUG mkdir -p $BACKUPDIR
	echo "done."
fi

# change to the dotfiles directory
echo -n "Changing to the $dotdir directory... "
cd "$dotdir"
echo "done."

# move any existing dotfiles in $HOME to $BACKUPDIR, then create symlinks from
# to any files $dotdir that are specified in $files
for file in $files; do

	dotDIR="$(dirname "$file")"
	dotBASE="$(basename "$file")"

	if [ "$dotDIR" == "." ]; then
		DESTDIR="$HOME"
		DESTBASE=".$dotBASE"
		DESTPATH="$HOME/$DESTBASE"
	else
		DESTDIR="$HOME/.$dotDIR"
		DESTBASE="$dotBASE"
		DESTPATH="$HOME/.$dotDIR/$DESTBASE"
	fi

#	echo "DESTDIR  = $DESTDIR"
#	echo "DESTITEM = $DESTITEM"
#	echo "DESTPATH = $DESTPATH"

	# Create any missing directories.
	[[ ! -d "$DESTDIR" ]] && $DEBUG mkdir -p "$DESTDIR"

	# If the dotfile exists, and it's a regular file, then move it to
	# $BACKUPDIR for backup.
	if [ -f "$HOME/.$file" ] && [ ! -h "$HOME/.$file" ]; then
		echo "Moving existing ~/.$file to $BACKUPDIR"
		$DEBUG mkdir -p "$BACKUPDIR/$(dirname "$file")"
		$DEBUG mv "$HOME/.$file" "$BACKUPDIR/$file"

	# If the destination is a directory, and not a symbolic link, then move it
	# to $BACKU{DIR for backup.
	elif [ -d "$DESTPATH" ] && [ ! -h "$DESTPATH" ]; then
		#$DEBUG rsync --remove-source-files -av $HOME/.fonts/Inconsolata-powerline $BACKUPDIR/fonts
		#$DEBUG rm -rf $HOME/.fonts/Inconsolata-powerline
		echo "Backing up $DESTPATH to $BACKUPDIR"
		$DEBUG mkdir -p $BACKUPDIR/$file
		$DEBUG rsync --remove-source-files -a "$DESTPATH/" $BACKUPDIR/$file/
		$DEBUG rm -rf $DESTPATH

	# If the dotfile exists as a symbolic link, and it doesn't point
	# to the correct file, then move it to $BACKUPDIR for backup.
	elif [ -h "$DESTPATH" ] && [ "$(realpath $DESTPATH)" != "$(realpath $dotdir/$file)" ]; then
		echo "Backing up $DESTPATH to ${BACKUPDIR}/$file"
		$DEBUG mv "$DESTPATH" "$BACKUPDIR/$file"
	fi

	if [ ! -e "$DESTPATH" ]; then
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
