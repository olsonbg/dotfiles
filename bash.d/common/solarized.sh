# Set SOLARIZED_THEME environment variable based on currently
# used ~/.Xresources file.
solarized_theme() {
	SOLARIZED_THEME=$(basename $(readlink ~/.Xresources))
	export SOLARIZED_THEME=${SOLARIZED_THEME/Xresources-/}
}

solarized-curr-colors() {
	# Get the foreground, background, and cursor colors.
	# from ~/.Xresources
	local FG=$(sed -e '/^#define S_base0 /!d' -e 's/^#define S_base0 *//' ~/.Xresources)
	local BG=$(sed -e '/^#define S_base03/!d' -e 's/^#define S_base03 *//' ~/.Xresources)
	local CU=$(sed -e '/^#define S_base1 /!d' -e 's/^#define S_base1 *//' ~/.Xresources)
	local Solarized='\033]10;'$FG'\007\033]11;'$BG'\007\033]12;'$CU'\007'

	# Update the colors
	echo -ne "${Solarized}"
}

solarized-dark() {
	ln -sf ~/dotfiles/Xresources-dark ~/.Xresources
	eval $(dircolors ~/.bash.d/themes/dircolors.ansi-dark)

	if [ -n "$DISPLAY" ]; then
		# Only run xrdb if in X.
		xrdb ~/.Xresources
	fi

	solarized-curr-colors
}

solarized-light() {
	ln -sf ~/dotfiles/Xresources-light ~/.Xresources
	eval $(dircolors ~/.bash.d/themes/dircolors.ansi-light)

	if [ -n "$DISPLAY" ]; then
		# Only run xrdb if in X.
		xrdb ~/.Xresources
	fi

	solarized-curr-colors
}

#Toggle solarized light and dark themes.
solarized() {

	[[ -n "$SOLARIZED_THEME" ]] && solarized_theme

	if [ "$SOLARIZED_THEME" == "dark" ]; then
		solarized-light
	elif [ "$SOLARIZED_THEME" == "light" ]; then
		solarized-dark
	fi


	# Update the environmental variable.
	solarized_theme
}

solarized_theme
