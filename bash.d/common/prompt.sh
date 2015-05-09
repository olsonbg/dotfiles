# Some convenient color definitions:
YEL='\033[1;33m'
BRN='\033[43m'
WHT='\033[1;37m'
RED='\033[1;31m'
NONE='\033[0m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
E='\['
R='\]'

#TTYPNUM=`tty|cut -c9,10`
SUS=`ps T |grep -v "grep"|grep -c " su"|grep -v "^0"`

if [ $TERM = "linux"  -o $TERM = "xterm" -o $TERM = "xterm-256color" -o $TERM = "rxvt-unicode-256color" -o $TERM = "screen-256color" ] ; then
	export PS1="$E$CYAN$R\h($E$YEL$R\u$E$CYAN$R)[$E$RED$R\$?$E$CYAN$R]$E$YEL$R$SUS$E$NONE$CYAN$R:\w/"'$(__git_ps1 " [%s]")'">$E$NONE$R "
elif [ $TERM = "screen-256color" ]; then
	export PS1="$E$BLUE$R\h($E$YEL$R\u$E$BLUE$R)[$E$RED$R\$?$E$BLUE$R]$E$YEL$R$SUS$E$NONE$BLUE$R:\w/"'$(__git_ps1 " [%s]")'">$E$NONE$R "
	
else
	export PS1="\h(\u)[\$?]$SUS:\w/"'$(__git_ps1 " [%s]")'"> "
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWSTASHSTATE=1
#
# unset values...
#
unset YEL
unset BRN
unset WHT
unset RED
unset NONE
unset CYAN
unset BLUE
unset E
unset R
