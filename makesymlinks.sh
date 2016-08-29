#!/bin/bash
#
# This script creates symlinks from the home directory to the dotfiles.
# Existing dotfiles are moved to the $INSTALLDIR/dotfiles-<datetime> directory.
#

# Uncomment the DEBUG line for debugging
#DEBUG=echo

INSTALLDIR="$HOME"

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
	local dfile="$1"  # List of object to link to.
	local dp="$2"     # location of objects in $dfile, relative to $dotdir.
	local I="$3"      # Directory to install symbolic links
	local d="$4"      # Prefix for each $dfile object (e.g., '.')
	local backup="$5" # Directory for backups.

	local file
	local SRCPATH     # Full path of object to link to.
	local DESTPATH    # Full path of the symbolic link to create.
	local DESTDIR     # Directory where the symbolic link will be created.
	local DESTBASE    # Name of symbolic link to create.

	# move any existing dotfiles in $INSTALLDIR to $BACKUPDIR, then create
	# symlinks from to any files $dotdir that are specified in $files
	while IFS= read -r -d $'\n' file ; do
		[[ -z "$file" ]] && continue

		dotDIR="$(dirname "$file")"
		dotBASE="$(basename "$file")"

		SRCPATH="$dotdir/$dp/$file"

		if [ "$dotDIR" == "." ]; then
			BKPDIR="$backup"
			DESTPATH="$I/$d$dotBASE"
		else
			BKPDIR="$backup/$dotDIR"
			DESTPATH="$I/$d$dotDIR/$dotBASE"
		fi

		DESTBASE="$(basename "$DESTPATH")"
		DESTDIR="$(dirname "$DESTPATH")"

		# Create any missing directories.
		[[ ! -d "$DESTDIR" ]] && $DEBUG mkdir -p "$DESTDIR"

		# If the dotfile exists, and it's a regular file, then move it to
		# $BACKUPDIR for backup.
		if [ -f "$DESTPATH" ] && [ ! -h "$DESTPATH" ]; then
			[[ ! -d "$BKPDIR" ]] && $DEBUG mkdir -p "$BKPDIR"
			$DEBUG mv "$DESTPATH" "$backup/$file"

		# If the destination is a directory, and not a symbolic link, then move
		# it to $BACKUPDIR for backup.
		elif [ -d "$DESTPATH" ] && [ ! -h "$DESTPATH" ]; then
			[[ ! -d "$BKPDIR" ]] && $DEBUG mkdir -p "$BKPDIR"
			$DEBUG rsync --remove-source-files -a "$DESTPATH/" $backup/$file/
			$DEBUG rm -rf $DESTPATH

		# If the dotfile exists as a symbolic link, and it doesn't point
		# to the correct file, then move it to $BACKUPDIR for backup.
		elif [ -h "$DESTPATH" ] &&  ! $(canonpatheq "$DESTPATH" "$SRCPATH") ; then
			[[ ! -d "$BKPDIR" ]] && $DEBUG mkdir -p "$BKPDIR"
			$DEBUG mv "$DESTPATH" "$backup/$file"
		fi

		# Create the symbolic link
		if [ ! -e "$DESTPATH" ]; then
			OFILE=$(canonpath "$SRCPATH")

			# Unfortunately, the cleanest way to determine relative paths
			# is to use perl. I could use full paths, but I prefer relative
			# here.
			relpath=$(perl -e 'use File::Spec; print File::Spec->abs2rel(@ARGV) . "\n"' "$OFILE" "$DESTDIR")
			$DEBUG ln -sv "$relpath" "$DESTPATH"
		fi

	done <<<"$dfile"
}

# The directory where this script is located and all the dotfiles
# should be linked to.
dotdir=$(canondir "$0")

# Get list of files to symbolically link to.
dfiles="$(find "$dotdir/files" -type f ! -name "*~" -printf "%P\n")"

dbin="$(find "$dotdir/bin" -type f ! -name "*~" -printf "%P\n")"
dbin="$dbin"$'\n'"$(find "$dotdir/bin" -type l ! -name "*~" -printf "%P\n")"

ddirs="$(find "$dotdir/dirs" -maxdepth 1 -type d ! -name "*~" -printf "%P\n")"

dfonts="$(find "$dotdir/fonts" -maxdepth 1 -type d ! -name "*~" -printf "%P\n")"

dconfig="$(find "$dotdir/config" ! -type d ! -name "*~" -printf "%P\n")"

# backups directory for existing dotfiles
BACKUPDIR="$INSTALLDIR/dotfiles-$(date +%Y%m%d-%H%M%S)"


# create dotfiles backup directory
if [ ! -d "$BACKUPDIR" ] && [ -z "$DEBUG" ]; then
	$DEBUG mkdir -p $BACKUPDIR
fi

echo "Dotfiles directory: $dotdir."
echo "Backup directory  : $BACKUPDIR."
echo

# change to the dotfiles directory
cd "$dotdir"

doLinking "$dfiles" "files" "$INSTALLDIR"        "." "$BACKUPDIR"
doLinking "$ddirs"  "dirs"  "$INSTALLDIR"        "." "$BACKUPDIR"
doLinking "$dbin"   "bin"   "$INSTALLDIR/bin"    ""  "$BACKUPDIR/bin"
doLinking "$dfonts" "fonts" "$INSTALLDIR/.fonts" ""  "$BACKUPDIR/fonts"

# For config files, if $XDG_CONFIG_HOME is not defined, or $INSTALLDIR is not
# equal to $HOME (for testing purposes mostly), install in $INSTALLDIR/.config.
# Otherwise, install in $XDG_CONFIG_HOME.
if [ -z "$XDG_CONFIG_HOME" ] || [ "$INSTALLDIR" != "$HOME" ]; then
	doLinking "$dconfig" "config" "$INSTALLDIR/.config" "" "$BACKUPDIR/config"
else
	doLinking "$dconfig" "config" "$XDG_CONFIG_HOME"    "" "$BACKUPDIR/config"
fi

# Create default Xresources current-scheme file.
if [ ! -e ~/.Xresources.d/current-scheme ] && [ -z "$DEBUG" ]; then
	echo "#define SOLARIZED_LIGHT" > ~/.Xresources.d/current-scheme
fi

# Create default tmux current-scheme file.
if [ ! -e ~/.tmux.d/current-scheme ] && [ -z "$DEBUG" ]; then
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
menus/install.sh
echo
echo "Setup complete."
