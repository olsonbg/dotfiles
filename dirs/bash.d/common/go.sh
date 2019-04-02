# Add ${HOME}/go/bin to PATH, if it exists.
TADDPATH="${HOME}/go/bin"
if [ -d "$TADDPATH" ]; then
	TPATH=""

	if [ $(echo $PATH|grep -c "$TADDPATH") == "0" ]; then
		TPATH="$TADDPATH:$PATH"
	fi

	[[ -n "$TPATH" ]] && export PATH="$TPATH"

	unset TPATH
fi
unset TADDPATH
