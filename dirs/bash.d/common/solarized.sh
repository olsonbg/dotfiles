# Get the current color scheme
solarized-getScheme() {
	local currentScheme=~/.Xresources.d/current-scheme

	if [ ! -e "$currentScheme" ]; then
		# Set default scheme to SOLARIZED_LIGHT.
		solarized-setScheme LIGHT
	fi

	# Get the current color scheme
	sed -e "s:^#define SOLARIZED_::" "$currentScheme"|tr [:upper:] [:lower:]
}

# Set the current color scheme
solarized-setScheme() {
	local currentScheme=~/.Xresources.d/current-scheme

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

solarized-tmux() {
	echo "source-file ~/.tmux.d/solarized-$(solarized-getScheme)" > .tmux.d/current-scheme
}

# Update configuration of programs that use solarized color scheme.
solarized-misc() {
	# Set dircolors
	eval $(dircolors ~/.bash.d/themes/dircolors.ansi-${1})

	# Set colors for tmux
	echo "source-file ~/.tmux.d/solarized-${1}" > ~/.tmux.d/current-scheme

	# If tmux server is running, tell it to reload tmux.conf
	if tmux info &>/dev/null; then
		tmux source-file ~/.tmux.conf >/dev/null
	fi
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

	# Update the programs that use solarized scheme.
	solarized-misc "$1"
}

solarized-dark() {
	solarized-switch dark
}

solarized-light() {
	solarized-switch light
}

#Toggle solarized light and dark themes.
solarized() {
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

# Update the programs that use solarized scheme.
solarized-misc $(solarized-getScheme)
