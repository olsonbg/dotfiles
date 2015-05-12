# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups:ignorespace

export HISTSIZE=100000           # big big history
export HISTFILESIZE=100000       # big big history
shopt -s histappend              # append to history, don't overwrite it
