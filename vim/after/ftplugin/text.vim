setlocal textwidth=76
setlocal spell spelllang=en_us

inoremap <buffer> <tab> <c-r>=Smart_TabComplete(1,1)<CR>
inoremap <buffer> <s-tab> <c-r>=Smart_TabComplete(0,1)<CR>
