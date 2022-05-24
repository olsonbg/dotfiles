" For composing a message with mutt
set tw=76 softtabstop=4 expandtab
" Setting "X-Editor":
" Let Vim identify itself in the message header
" when editing emails with Mutt and Slrn:
let verstring=v:version/100.0
let @"="X-Editor: VIM - Vi IMproved v".verstring." http://www.vim.org/\n"|exe 'norm 1G}""P'

map ,cs msHmtgg/Subject:\s*/e<CR>:noh<CR>D"=strftime(" %Y %b %d")<CR>p'tzt`s
map ,as msHmtgg/Subject:\s*/e<CR>:noh<CR>Da 
map ,at msHmtgg/To:\s*/e<CR>:noh<CR>Da 

hi mailHeader    ctermfg=Yellow      guifg=LightYellow
hi mailHeaderKey ctermfg=DarkCyan    guifg=DarkCyan
hi mailSubject   ctermfg=Brown       guifg=Brown 
hi mailEmail     ctermfg=Yellow      guifg=Yellow
hi mailQuoted1   ctermfg=green       guifg=green
hi mailSignature ctermfg=Red         guifg=DarkRed
