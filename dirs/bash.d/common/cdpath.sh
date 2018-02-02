add_uniq_cdpath() {
	local TPATH="$1"

	if ! $(echo $CDPATH|grep -q "$TPATH") ; then
		[[ -d "$TPATH" ]] && CDPATH=$CDPATH:$TPATH
	fi
}


add_uniq_cdpath $HOME/Projects
add_uniq_cdpath $HOME/go/src
unset add_uniq_cdpath

# vim: ft=sh
