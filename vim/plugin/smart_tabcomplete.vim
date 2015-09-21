function! Smart_TabComplete(isDown, isText)
	if ( pumvisible() )  " Popup is visible, select next item.
		if ( a:isDown )
			return "\<C-n>"
		else
			return "\<C-p>"
		endif
	endif

	let line = getline('.')                   " current line

	let substr = strpart(line, -1, col('.')+1) " from the start of the current
	" line to one character right
	" of the cursor
	let substr = matchstr(substr, "[^ \t]*$") " word till cursor
	if (strlen(substr)==0)                    " nothing to match on empty string
		return "\<tab>"
	endif
	" Search for file matching in any file type, text or code.
	let has_slash = match(substr, '\/') != -1 " position of slash, if any
	if ( has_slash )
		return "\<C-X>\<C-F>"                 " file matching
	endif

	if ( a:isText )
		return "\<C-X>\<C-P>"                 " existing text matching
	endif

	if ( &omnifunc == "" )
		return ""
	endif

	return "\<C-x>\<C-o>\<C-n>\<C-p>"        " for omnicomplete
endfunction
