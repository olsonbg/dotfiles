# Set SOLARIZED_THEME environment variable based on currently
# used ~/.Xresources file.
solarized_theme() {
	SOLARIZED_THEME=$(basename $(readlink ~/.Xresources))
	export SOLARIZED_THEME=${SOLARIZED_THEME/Xresources-/}


	# Make sure the dircolors theme matches the current
	# solarized theme (dark/light).
	if [ "$SOLARIZED_THEME" == "dark" ]; then
		eval $(dircolors ~/.bash.d/themes/dircolors.ansi-light)
	elif [ "$SOLARIZED_THEME" == "light" ]; then
		eval $(dircolors ~/.bash.d/themes/dircolors.ansi-dark)
	fi
}

#Toggle solarized light and dark themes.
solarized() {
	if [ "$SOLARIZED_THEME" == "dark" ]; then
		ln -sf ~/dotfiles/Xresources-light ~/.Xresources
	elif [ "$SOLARIZED_THEME" == "light" ]; then
		ln -sf ~/dotfiles/Xresources-dark ~/.Xresources
	fi

	if [ -n "$DISPLAY" ]; then
		# Only run xrdb if in X.
		xrdb ~/.Xresources
	fi

	# Get the foreground, background, and cursor colors.
	local FG=$(sed -e '/^#define S_base0 /!d' -e 's/^#define S_base0 *//' ~/.Xresources)
	local BG=$(sed -e '/^#define S_base03/!d' -e 's/^#define S_base03 *//' ~/.Xresources)
	local CU=$(sed -e '/^#define S_base1 /!d' -e 's/^#define S_base1 *//' ~/.Xresources)
	local Solarized='\033]10;'$FG'\007\033]11;'$BG'\007\033]12;'$CU'\007'

	# Update the colors
	echo -ne "${Solarized}"

	# Update the environmental variable and dircolors.
	solarized_theme
}

solarized_theme
