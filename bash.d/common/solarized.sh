# Set SOLARIZED_THEME environment variable based on currently
# used ~/.Xresources file.
solarized_theme() {
	SOLARIZED_THEME=$(basename $(readlink ~/.Xresources))
	export SOLARIZED_THEME=${SOLARIZED_THEME/Xresources-/}
}

#Toggle solarized light and dark themes.
solarized() {
	if [ "$SOLARIZED_THEME" == "dark" ]; then
		echo "Setting solarized theme to light."
		ln -sf ~/dotfiles/Xresources-light ~/.Xresources
		xrdb ~/.Xresources
		# echo -e "${SolarizedLight}"
	elif [ "$SOLARIZED_THEME" == "light" ]; then
		echo "Setting solarized theme to dark."
		ln -sf ~/dotfiles/Xresources-dark ~/.Xresources
		xrdb ~/.Xresources
		# echo -e "${SolarizedDark}"
	else
		echo "Can not determine current theme."
		return
	fi

	# Get the foreground, background, and cursor colors.
	local FG=$(sed -e '/^#define S_base0 /!d' -e 's/^#define S_base0 *//' ~/.Xresources)
	local BG=$(sed -e '/^#define S_base03/!d' -e 's/^#define S_base03 *//' ~/.Xresources)
	local CU=$(sed -e '/^#define S_base1 /!d' -e 's/^#define S_base1 *//' ~/.Xresources)
	local Solarized='\033]10;'$FG'\007\033]11;'$BG'\007\033]12;'$CU'\007'

	# Update the colors
	echo -e "${Solarized}"

	# Update the environmental variable
	solarized_theme
}

solarized_theme
