# Set SOLARIZED_THEME environment variable based on currently
# used ~/.Xresources file.
solarized_theme() {
	SOLARIZED_THEME=$(basename $(readlink ~/.Xresources))
	export SOLARIZED_THEME=${SOLARIZED_THEME/Xresources-/}
}

solarized-get-color() {
	sed -e "/^#define $2 /!d" -e "s/^#define $2 *//" $1
}

solarized-curr-colors() {
	# Get the foreground, background, and cursor colors.
	# from ~/.Xresources
	local resourceFile=~/dotfiles/Xresources-$1
	if [ ! -e "$resourceFile" ]; then
		echo "[solarized-curr-colors()] File not found: $resourceFile"
		return
	fi

	local COLOR0=$(solarized-get-color  $resourceFile "S_base02")
	local COLOR7=$(solarized-get-color  $resourceFile "S_base2")
	local COLOR8=$(solarized-get-color  $resourceFile "S_base03")
	local COLOR10=$(solarized-get-color $resourceFile "S_base01")
	local COLOR11=$(solarized-get-color $resourceFile "S_base00")
	local COLOR12=$(solarized-get-color $resourceFile "S_base0")
	local COLOR14=$(solarized-get-color $resourceFile "S_base1")
	local COLOR15=$(solarized-get-color $resourceFile "S_base3")

	local FG=$COLOR12
	local BG=$COLOR8
	local CU=$COLOR14

	local Solarized='\033]10;'$FG'\007'
	Solarized=$Solarized'\033]11;'$BG'\007'
	Solarized=$Solarized'\033]12;'$CU'\007'
	Solarized=$Solarized'\033]4;0;'$COLOR0'\007'
	Solarized=$Solarized'\033]4;7;'$COLOR7'\007'
	Solarized=$Solarized'\033]4;8;'$COLOR8'\007'
	Solarized=$Solarized'\033]4;10;'$COLOR10'\007'
	Solarized=$Solarized'\033]4;11;'$COLOR11'\007'
	Solarized=$Solarized'\033]4;12;'$COLOR12'\007'
	Solarized=$Solarized'\033]4;14;'$COLOR14'\007'
	Solarized=$Solarized'\033]4;15;'$COLOR15'\007'

	# Update the color palette and foreground, background, and cursor color.
	echo -ne "${Solarized}"
}

solarized-dark() {
	ln -sf ~/dotfiles/Xresources-dark ~/.Xresources
	eval $(dircolors ~/.bash.d/themes/dircolors.ansi-dark)

	if [ -n "$DISPLAY" ]; then
		# Only run xrdb if in X.
		xrdb ~/dotfiles/Xresources-dark
	fi

	solarized-curr-colors dark
}

solarized-light() {
	ln -sf ~/dotfiles/Xresources-light ~/.Xresources
	eval $(dircolors ~/.bash.d/themes/dircolors.ansi-light)

	if [ -n "$DISPLAY" ]; then
		# Only run xrdb if in X.
		xrdb ~/dotfiles/Xresources-light
	fi

	solarized-curr-colors light
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
