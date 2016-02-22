setlocal textwidth=76
setlocal spell spelllang=en_us

function! MarkdownView()
	if &filetype != "markdown"
		echo "Not a markdown file according to 'set filetype?'"
		return
	endif
	write
	let l:htmlfile = "/dev/shm/".expand('%:t').".html"
	silent execute "!mdv \"".expand('%:p')."\" \"".l:htmlfile."\""
	redraw!
endfunction

" Convert markdown to html and show in browser.
noremap  <buffer> <silent> <F4> :call MarkdownView()<CR>
noremap! <buffer> <silent> <F4> <ESC> :call MarkdownView()<CR>
