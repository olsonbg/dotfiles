if [ "$TERM" != "dumb" ]; then
	NUMCOLORS=$(tput colors)
fi

case "$NUMCOLORS" in
	256) export TERM=xterm-256color
	     ;;
	*)   export TERM=xterm-color
esac
