#!/bin/sh
#

NUMCOLORS=$(tput colors)

case "$NUMCOLORS" in
	256) export TERM=xterm-256color
	     ;;
	*)   export TERM=xterm-color
esac
