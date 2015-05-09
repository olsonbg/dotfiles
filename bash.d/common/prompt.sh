function __prompt_command()
{
	EXIT="$?"
	PS1=""

	# Some convenient color definitions:
	local E='\[\033'
	local R='\]'
	local YEL=$E'[0;33m'$R
	local BRN=$E'[43m'$R
	local WHT=$E'[0;37m'$R
	local RED=$E'[0;31m'$R
	local CYAN=$E'[0;36m'$R
	local BLUE=$E'[0;34m'$R
	local GREEN=$E'[0;32m'$R
	local PURPLE=$E'[0;35m'$R
	local NONE=$E'[0m'$R

	SUS=`ps T |grep -v "grep"|grep -c " su"|grep -v "^0"`


	if [ $EXIT -eq 0 ]; then 
		PS1+="$GREEN[\!]$NONE";
	else
		PS1+="$RED[\!]$NONE";
	fi

	PS1+="$CYAN\h$CYAN($YEL\u$CYAN)$NONE"
	PS1+="$YEL$SUS$NONE"
	PS1+="$CYAN:\W$NONE"

	local git_status="$(git status 2>&1)"
	local Color_On
	local branch
	if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
		if [[ "$git_status" =~ nothing\ to\ commit ]]; then
			Color_On=$GREEN;
		elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
			Color_On=$PURPLE;
		else
			Color_On=$RED;
		fi

		if [[ $git_status =~ On\ branch\ ([^[:space:]]+) ]]; then
			branch=${BASH_REMATCH[1]};
		else
			branch=$(git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD)
		fi

		local s
		if $(git rev-parse --verify --quiet refs/stash >/dev/null); then
			s="$"
		fi
		PS1+=" $Color_On[$branch$s]$NONE"
	fi

	# PS1+='$(__git_ps1 " [%s]")'
	PS1+="\$ "

	# if [ $TERM = "linux"  -o $TERM = "xterm" -o $TERM = "xterm-256color" -o $TERM = "rxvt-unicode-256color" -o $TERM = "screen-256color" ] ; then
	#     export PS1="[\!]$GREEN\h$CYAN($YEL\u$CYAN)[$RED\$?$CYAN]$YEL$SUS$CYAN:\w$YEL"'$(__git_ps1 " [%s]")'"$NONE\$ "
	# elif [ $TERM = "screen-256color" ]; then
	#     export PS1="$E$GREEN$R\h($E$YEL$R\u$E$BLUE$R)[$E$RED$R\$?$E$BLUE$R]$E$YEL$R$SUS$E$NONE$BLUE$R:\w"'$(__git_ps1 " [%s]")'"$E$NONE$R\$ "

	# else
	#     export PS1="\h(\u)[\$?]$SUS:\w/"'$(__git_ps1 " [%s]")'"$ "
	# fi
}

PROMPT_COMMAND=__prompt_command
