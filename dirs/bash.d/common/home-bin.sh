# Add ${HOME}/bin to PATH, if it exists.
if [ -d "${HOME}/bin" ]; then
	TPATH=""

	if [ $(echo $PATH|grep -c "${HOME}/bin") == "0" ]; then
		TPATH="$PATH:${HOME}/bin"
	fi

	[[ -n "$TPATH" ]] && export PATH="$TPATH"

	unset TPATH
fi

