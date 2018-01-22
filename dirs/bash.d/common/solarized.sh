# Get the current color scheme
solarized-getScheme() {
	local currentScheme=~/.Xresources.d/current-scheme

	if [ ! -e "$currentScheme" ]; then
		# Set default scheme to SOLARIZED_LIGHT.
		solarized-setScheme LIGHT
	fi

	# Get the current color scheme
	sed -e "s:^#define SOLARIZED_::" "$currentScheme"|tr '[:upper:]' '[:lower:]'
}

# Set the current color scheme
solarized-setScheme() {
	local currentScheme=~/.Xresources.d/current-scheme

	# Set the current color scheme
	echo "#define SOLARIZED_${1^^}" > $currentScheme
}

# Convert solarized color names (S_baseXX) to hex value.
solarized-getColor() {
	sed -e "/^#define $2 /!d" -e "s/^#define $2 *//" $1
}

# Convert solarized color names (S_baseXX, red,...) to color number in X server
# resource database, as defined in ~/.Xresources.d/solarized-scheme.
solarized-StoN() {
	local solarizedScheme=~/.Xresources.d/solarized-scheme

	sed -e "/^\*color.* *$1$/!d" -e "s/^\*color\(.*\): *$1$/\1/" $solarizedScheme
}

# Set dircolors
solarized-dircolors() {
	eval $(dircolors ~/.bash.d/themes/dircolors.ansi-${1})
}

solarized-tmux() {
	echo "source-file ~/.tmux.d/solarized-$(solarized-getScheme)" > ~/.tmux.d/current-scheme
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

	export LESS_TERMCAP_mb=$(tput setaf $(solarized-StoN S_red)) # blinking
	export LESS_TERMCAP_me=$(tput sgr0) # Normal
	export LESS_TERMCAP_us=$(tput smul) # Start underline
	export LESS_TERMCAP_ue=$(tput rmul) # End underline

	case "$1" in
		dark)
			# Start bold mode
			export LESS_TERMCAP_md=$(tput setaf $(solarized-StoN S_base2))
			# Start and end standout
			export LESS_TERMCAP_so=$(tput setaf $(solarized-StoN S_base1))$(tput setab $(solarized-StoN S_base02))
			export LESS_TERMCAP_se=$(tput setaf $(solarized-StoN S_base0))$(tput setab $(solarized-StoN S_base03))
			;;
		light)
			# Start bold mode
			export LESS_TERMCAP_md=$(tput setaf $(solarized-StoN S_base02))
			# Start and end standout
			export LESS_TERMCAP_so=$(tput setaf $(solarized-StoN S_base01))$(tput setab $(solarized-StoN S_base2))
			export LESS_TERMCAP_se=$(tput setaf $(solarized-StoN S_base00))$(tput setab $(solarized-StoN S_base3))
			;;
		*)
			echo "[solarized(), called from less.sh] Unknown color scheme."
			;;
	esac
	# The LESS_TERMCAP_se definitions above work, except inside tmux. Therefore
	# I use the following
	export LESS_TERMCAP_se=$(tput sgr0) # To work inside tmux!
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
# Make sure TERM is not dumb.
[[ "$TERM" != "dumb" ]] && solarized-misc $(solarized-getScheme)
