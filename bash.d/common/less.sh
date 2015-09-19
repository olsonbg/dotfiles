export LESSOPEN="|lesspipe.sh %s"
export LESSCOLOR="always"
export LESS_TERMCAP_so=$(tput setaf 3)$(tput setab 7)
export LESS_TERMCAP_se=$(tput sgr0)
export LESS="-R -M"

# vim: ft=sh
