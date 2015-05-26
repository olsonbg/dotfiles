# Use my caps lock key as a control key.
if [ ! -z $DISPLAY ]; then
	setxkbmap -option ctrl:nocaps
fi
