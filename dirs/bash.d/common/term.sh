# The solarized scheme of Vim looks at the variable TERM_PROGRAM to determine
# if the terminal supports italic fonts. rxvt does support italics, so I set it
# here, if I'm using rxvt.
[[ "${TERM:0:4}" == "rxvt" ]] && export TERM_PROGRAM=urxvtd
# I use xft for xterm fonts, so it also supports italics. Some characters do
# get cut off a little but, but that's okay with me. I rarely use xterm anyway.
# [[ "${TERM:0:5}" == "xterm" ]] && export TERM_PROGRAM=urxvtd

# Set TERM to a standard value, depending upon to color capabilities of the
# terminal.
#if [ "$TERM" != "dumb" ]; then
#	NUMCOLORS=$(tput colors)
#fi

#case "$NUMCOLORS" in
#	256) export TERM=xterm-256color
#	     ;;
#	*)   export TERM=xterm-color
#esac

