setlocal noexpandtab
setlocal autoindent
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal formatoptions=croql

inoremap <buffer>   <tab> <c-r>=Smart_TabComplete(1,0)<CR>
inoremap <buffer> <s-tab> <c-r>=Smart_TabComplete(0,0)<CR>
