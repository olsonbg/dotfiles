# Get the current color scheme
solarized-getScheme() {
	local currentScheme=~/.Xresources.d/current-scheme

	if [ ! -e "$currentScheme" ]; then
		echo "[solarized-getScheme()] File not found: $currentScheme"
		return
	fi
	# Get the current color scheme
	sed -e "s:^#define SOLARIZED_::" "$currentScheme"|tr [:upper:] [:lower:]
}

# Set the current color scheme
solarized-setScheme() {
	local currentScheme=~/.Xresources.d/current-scheme

	local scheme=
	# Set the current color scheme
	echo "#define SOLARIZED_${1^^}" > $currentScheme
}

solarized-getColor() {
	sed -e "/^#define $2 /!d" -e "s/^#define $2 *//" $1
}

# Set dircolors
solarized-dircolors() {
	eval $(dircolors ~/.bash.d/themes/dircolors.ansi-${1})
}

solarized-switch() {
	local solarizedScheme=~/.Xresources.d/solarized-scheme

	if [ ! -e "$solarizedScheme" ]; then
		echo "[solarized-switch()] File not found: $solarizedScheme"
		return
	fi

	# Set the color scheme, and get its foreground and background colors
	solarized-setScheme "$1"

	if [ "$1" == "dark" ]; then
		local BG=$(solarized-getColor $solarizedScheme "S_base03")
		local FG=$(solarized-getColor $solarizedScheme "S_base0")
		export COLORFGBG="12;default;8"
	else # Assume 'light'
		local BG=$(solarized-getColor $solarizedScheme "S_base3")
		local FG=$(solarized-getColor $solarizedScheme "S_base00")
		export COLORFGBG="15;default;11"
	fi

	# Update to color pallette.
	if [ -n "$DISPLAY" ]; then
		# Only run xrdb if in X.
		xrdb ~/.Xresources
	fi

	local Solarized='\033]10;'$FG'\007'
	Solarized=$Solarized'\033]11;'$BG'\007'

	# Update the foreground and background.
	echo -ne "${Solarized}"

	# Update the dircolors.
	solarized-dircolors "$1"
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
	local SOLARIZED_SCHEME=$(solarized-getScheme)

	case "$(solarized-getScheme)" in
		dark)
			solarized-light
			;;
		light)
			solarized-dark
			;;
		*)
			echo "[solarized()] Unknown color scheme."
			;;
	esac
}

# Set dircolors to the currently used solarized scheme
solarized-dircolors $(solarized-getScheme)
