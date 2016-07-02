# Check battery status
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0; acpi -ib'
# powermanagement of quadtux-lan
alias sleepquadtux='ssh -n quadtux-lan sudo /usr/sbin/pm-suspend &'
#GRaph: graph -T ps -h 0.57 -w 0.8 -r 0.15 -u 0.215 -C -m -3 -S 16 -q 1
##############################
# Mail Stuff
#
alias frm='/usr/bin/mutt -Z'
#
##############################
# Printing
#
#alias a2ps="/usr/bin/a2ps -Mletter"
alias MYenscript="enscript -G2rE"
alias psdouble='pstops "2:0L@0.8(9.0in,-1.0in)+1L@0.8(9.0in,4.25in)"'
alias psdoublejournal='pstops "2:0L@0.75(8.5in,-0.5in)+1L@0.75(8.5in,4.75in)"'
# Use psbook first, then psdoublebook.
alias psdoublebook='pstops "2:0L@0.8(8.75in,-0.5in)+1L@0.8(8.75in,4.75in)"'
alias psdouble_aps='pstops "2:0L@0.8(8.6in,-0.5in)+1L@0.8(8.6in,4.75in)"'
#
#
##############################
# System Info and stuff
#
alias pstree="/usr/bin/pstree -aph"
alias ls="/bin/ls --color=auto"
# For looking at LaTeX directories
alias tls='/bin/ls --color=auto -B -I "*.aux" -I "*.bbl" -I "*.toc" -I "*.lof" -I "*.log" -I "*.lot" -I "*.blg" -I "*.cls" -I "*.bst"'
#
