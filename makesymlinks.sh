#!/bin/bash
#
# This script creates symlinks from the home directory to the dotfiles.
# Existing dotfiles are moved to the $HOME/dotfiles-<datetime> directory.
#

# Uncomment the DEBUG line for debugging
#DEBUG=echo

# list of files/folders to symlink in homedir
dfiles="bashrc vimrc screenrc screenrc-ide \
       tmux.conf Xresources ctags \
       terminfo gitignore_global gitconfig \
       config/openbox/lxde-rc.xml"

ddirs="bash.d tmux.d Xresources.d fonts/Inconsolata-powerline vim"

# Get the canonicalized path
canonpath() {
	readlink -f "$1"
}

# Get the canonicalized directory name
canondir() {
	dirname "$(canonpath "$1")"
}

# Check if canonicalized paths are the same
canonpatheq() {
	[[ "$(canonpath "$1")" == "$(canonpath "$2")" ]]
}

doLinking() {
	local dfile="$1"
	local dp="$2"
	local backup="$3"

	local file
	local DESTDIR
	local DESTBASE
	local DESTPATH

	# move any existing dotfiles in $HOME to $BACKUPDIR, then create symlinks from
	# to any files $dotdir that are specified in $files
	for file in $dfile; do

		dotDIR="$(dirname "$file")"
		dotBASE="$(basename "$file")"

		if [ "$dotDIR" == "." ]; then
			DESTDIR="$HOME"
			BKPDIR="$backup"
			DESTBASE=".$dotBASE"
			DESTPATH="$HOME/$DESTBASE"
		else
			DESTDIR="$HOME/.$dotDIR"
			BKPDIR="$backup/$dotDIR"
			DESTBASE="$dotBASE"
			DESTPATH="$HOME/.$dotDIR/$DESTBASE"
		fi

		# Create any missing directories.
		[[ ! -d "$DESTDIR" ]] && $DEBUG mkdir -p "$DESTDIR"

		# If the dotfile exists, and it's a regular file, then move it to
		# $BACKUPDIR for backup.
		if [ -f "$HOME/.$file" ] && [ ! -h "$HOME/.$file" ]; then
			[[ ! -d "$BKPDIR" ]] && $DEBUG mkdir -p "$BKPDIR"
			$DEBUG mv "$HOME/.$file" "$backup/$file"

		# If the destination is a directory, and not a symbolic link, then move
		# it to $BACKUPDIR for backup.
		elif [ -d "$DESTPATH" ] && [ ! -h "$DESTPATH" ]; then
			[[ ! -d "$BKPDIR" ]] && $DEBUG mkdir -p "$BKPDIR"
			$DEBUG rsync --remove-source-files -a "$DESTPATH/" $backup/$file/
			$DEBUG rm -rf $DESTPATH

		# If the dotfile exists as a symbolic link, and it doesn't point
		# to the correct file, then move it to $BACKUPDIR for backup.
		elif [ -h "$DESTPATH" ] &&  ! $(canonpatheq "$DESTPATH" "$dotdir/$dp/$file") ; then
			[[ ! -d "$BKPDIR" ]] && $DEBUG mkdir -p "$BKPDIR"
			$DEBUG mv "$DESTPATH" "$backup/$file"
		fi

		# Create the symbolic link
		if [ ! -e "$DESTPATH" ]; then
			OFILE=$(canonpath "$dotdir/$dp/$file")
			LFILE="$HOME/.$file"

			# Unfortunately, the cleanest way to determine relative paths
			# is to use perl. I could use full paths, but I prefer relative
			# here.
			relpath=$(perl -e 'use File::Spec; print File::Spec->abs2rel(@ARGV) . "\n"' "$OFILE" $(dirname "$LFILE"))
			$DEBUG ln -sv "$relpath" "$LFILE"
		fi

	done
}

# The directory where this script is located and all the dotfiles
# should be linked to.
dotdir=$(canondir "$0")

# backups directory for existing dotfiles
BACKUPDIR="$HOME/dotfiles-$(date +%Y%m%d-%H%M%S)"


# create dotfiles backup directory
if [ ! -d "$BACKUPDIR" ] && [ -z $DEBUG ]; then
	$DEBUG mkdir -p $BACKUPDIR
fi

echo "Dotfiles directory: $dotdir."
echo "Backup directory  : $BACKUPDIR."
echo

# change to the dotfiles directory
cd "$dotdir"

doLinking "$dfiles" "files" "$BACKUPDIR"
doLinking "$ddirs"  "dirs"  "$BACKUPDIR"

# Create default Xresources current-scheme file.
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
if [ -d "$BACKUPDIR" ] ; then
	ls -1qA "$BACKUPDIR" | grep -q .
	if [ $? -eq 1 ]; then
		echo -n "Backup directory empty, deleting it..."
		rm -rf "$BACKUPDIR"
		echo " done."
	fi
fi

echo
echo "Setup complete."
