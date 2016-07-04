#!/bin/sh

#BoldItalic:
tput sitm ; tput bold ;  echo 'Bold Italic.' ; tput sgr0

#Italic:
tput sitm ; echo 'Italic.' ; tput ritm

#Bold:
tput bold ; echo 'Bold.' ; tput sgr0

