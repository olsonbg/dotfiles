# Set SOLARIZED_THEME environment variable based on currently
# used ~/.Xresources file.
solarized-get-color() {
	sed -e "/^#define $2 /!d" -e "s/^#define $2 *//" $1
}

solarized-switch() {
	local resourceFile=~/dotfiles/Xresources-$1
	if [ ! -e "$resourceFile" ]; then
		echo "[solarized-curr-colors()] File not found: $resourceFile"
		return
	fi

	ln -sf $resourceFile ~/.Xresources


	if [ -n "$DISPLAY" ]; then
		# Only run xrdb if in X.
		xrdb $resourceFile
	fi

	# Get the foreground and background colors
	if [ "$1" == "dark" ]; then
		local BG=$(solarized-get-color $resourceFile "S_base03")
		local FG=$(solarized-get-color $resourceFile "S_base0")
		export COLORFGBG="12;default;8"
	else # Assume 'light'
		local BG=$(solarized-get-color $resourceFile "S_base3")
		local FG=$(solarized-get-color $resourceFile "S_base00")
		export COLORFGBG="15;default;11"
	fi

	local Solarized='\033]10;'$FG'\007'
	Solarized=$Solarized'\033]11;'$BG'\007'

	# Update the color palette and foreground, background, and cursor color.
	echo -ne "${Solarized}"

	# Update dircolors
	eval $(dircolors ~/.bash.d/themes/dircolors.ansi-${1})
}

solarized-dark() {
	solarized-switch dark
}

solarized-light() {
	solarized-switch light
}

#Toggle solarized light and dark themes.
solarized() {

	# Get the current scheme
	local SOLARIZED_SCHEME=$(basename $(readlink ~/.Xresources))
	SOLARIZED_SCHEME=${SOLARIZED_SCHEME/Xresources-/}

	echo "Solarized scheme: $SOLARIZED_SCHEME"
	if [ "$SOLARIZED_SCHEME" == "dark" ]; then
		solarized-switch light
	elif [ "$SOLARIZED_SCHEME" == "light" ]; then
		solarized-switch dark
	fi
}
