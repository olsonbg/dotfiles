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

	PS1+="$CYAN\h$CYAN($YEL\u$CYAN)$NONE"
	PS1+="$YEL$SUS$NONE"
	PS1+="$CYAN:\W$NONE"

	# Show virtualenv virtual environment if one is active
	if [ -n "$VIRTUAL_ENV" ];  then
		local virtualenv=$(basename "$VIRTUAL_ENV")
		PS1+="$CYAN(${PURPLE}v:$YEL$virtualenv$CYAN)$NONE"
	fi

	# Show conda virtual environment if one is active
	if [ -n "$CONDA_DEFAULT_ENV" ]; then
		PS1+="$CYAN(${PURPLE}c:$YEL$CONDA_DEFAULT_ENV$CYAN)$NONE"
	fi

	# Show SLURM jobid if in a slurm environment (salloc or srun)
	if [ -n "$SLURM_JOBID" ]; then
		PS1+="$CYAN(${PURPLE}jobid:$YEL$SLURM_JOBID$CYAN)$NONE"
	fi

	local git_status="$(git status 2>&1)"
	local Color_On
	local branch
	if ! [[ "$git_status" =~ [nN]ot\ a\ git\ repo ]]; then
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

		# Anything stashed?
		local s
		if $(git rev-parse --verify --quiet refs/stash >/dev/null); then
			s="$"
		fi

		# How many commits we are ahead/behind our upstream
		local p
		local count=$(git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null)

		case "$count" in
		"") # no upstream
			p="" ;;
		"0	0") # equal to upstream
			p="=" ;;
		"0	"*) # ahead of upstream
			p="+${count#0	}" ;;
		*"	0") # behind upstream
			p="-${count%	0}" ;;
		*)	    # diverged from upstream
			p="+${count#*	}-${count%	*}" ;;
		esac

		PS1+=" $Color_On[$branch$s$p]$NONE"
	fi

	# PS1+='$(__git_ps1 " [%s]")'

	if [ $EXIT -eq 0 ]; then
		# Green Unicode Digbats Heavy check mark
		PS1+=$GREEN$' \xE2\x9C\x94'$NONE;
	else
		# Red Unicode Digbats Heavy ballot X
		# Also turn the '$' red.
		PS1+=$RED$' \xE2\x9C\x98';
	fi

	PS1+="\$ $NONE"

	# if [ $TERM = "linux"  -o $TERM = "xterm" -o $TERM = "xterm-256color" -o $TERM = "rxvt-unicode-256color" -o $TERM = "screen-256color" ] ; then
	#     export PS1="[\!]$GREEN\h$CYAN($YEL\u$CYAN)[$RED\$?$CYAN]$YEL$SUS$CYAN:\w$YEL"'$(__git_ps1 " [%s]")'"$NONE\$ "
	# elif [ $TERM = "screen-256color" ]; then
	#     export PS1="$E$GREEN$R\h($E$YEL$R\u$E$BLUE$R)[$E$RED$R\$?$E$BLUE$R]$E$YEL$R$SUS$E$NONE$BLUE$R:\w"'$(__git_ps1 " [%s]")'"$E$NONE$R\$ "

	# else
	#     export PS1="\h(\u)[\$?]$SUS:\w/"'$(__git_ps1 " [%s]")'"$ "
	# fi
}

PROMPT_COMMAND=__prompt_command

# vim: ft=sh
