" Vim

"Use pathogen to load plugins in '~/.vim/bundles'
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

set incsearch
set formatoptions=tcqr
set cinoptions=(0
set laststatus=2
set tabstop=4
set shiftwidth=4
set showbreak=\ \ \ \ \ \
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " allow backspacing over everything in insert mode
set backup              " keep a backup file
set viminfo='20,\"50    " read/write a .viminfo file, don't store more
                        " than 50 lines of registers
set showcmd
set whichwrap=b,s,<,>,[,]
set printoptions=paper:letter
set listchars=tab:>-,trail:-
set list
" NERD Commenter
let NERDShutUp      = 1   " Don't warn on unsupported filetype
let NERDSpaceDelims = 1   " Put a space between comment delimiter and text
let mapleader       = '\' " Use \ as leader for NERD commands

" maps NERDTree to F10
" (normal, visual and operator-pending modes)
noremap <silent> <F10> :NERDTreeToggle<CR>
" (also in insert and command-line modes)
noremap! <silent> <F10> <ESC>:NERDTreeToggle<CR>

" Enable Vim 7+ spell checking
au BufRead *.tex setlocal spell spelllang=en_us
" Go to next misspelled word
map <F2> ]s
" Suggestions for misspelled word
map <F3> z=
" Convert each <TAB> in a selection to 4 <SPACE>s.
map ,ts :s/\t/    /g<CR>:noh<CR>

" In text files, always limit the width of text to 76 characters
autocmd BufRead *.txt set tw=76
autocmd BufRead *.tex set tw=76
"autocmd BufRead *.html      set filetype=php
"autocmd BufRead *.php       set filetype=php
"autocmd BufRead *.inc       set filetype=php

function ComputeVer(verstring)
"  exe "let g:" . a:verstring . " = ". v:version/ 100
  let g:verstring = v:version/100
  let g:verstring = g:verstring.".".(v:version - g:verstring*100)
endfunction

command DiffOrig new|set bt=nofile|r #|0d_|diffthis|wincmd p|diffthis
" Don't use Ex mode, use Q for formatting
" map Q gqip
"map Q gqap

" used to format LaTeX documents
fun! TeX_par()
    if (getline(".") != "")
        let op_wrapscan = &wrapscan
        set nowrapscan
        let par_begin = '^%\|^\s*\\begin{\|^\s*\\\['
        let par_end = '^%\|^\s*\\end{\|^\s*\\\]'
        exe '?'.par_end.'?+'
        norm V
        exe '/'.par_begin.'/-'
        norm gq
        let &wrapscan = op_wrapscan
    endif
endfun

autocmd BufRead *.tex        map Q :call TeX_par()<CR>
autocmd BufRead *.tex        map! ]i \item 
autocmd BufRead *.tex        map! ]bi \begin{itemize}
autocmd BufRead *.tex        map! ]ei \end{itemize}
autocmd BufRead *.tex        map! ]be \begin{enumerate}
autocmd BufRead *.tex        map! ]ee \end{enumerate}
autocmd BufRead *.tex        map! ]bd \begin{description}
autocmd BufRead *.tex        map! ]ed \end{description}
autocmd BufRead *.tex        map! ]bc \begin{center}
autocmd BufRead *.tex        map! ]ec \end{center}
autocmd BufRead *.tex        map! [be {\samepage\begin{eqnarray}
autocmd BufRead *.tex        map! [ee \end{eqnarray}}
autocmd BufRead *.tex        map! ]s1 \section{
autocmd BufRead *.tex        map! ]s2 \subsection{
autocmd BufRead *.tex        map! ]s3 \subsubsection{
autocmd BufRead *.tex        map! ]p1 \paragraph{
autocmd BufRead *.tex        map! ]p2 \subparagraph{
autocmd BufRead *.tex        map! ]f \frac{
autocmd BufRead *.tex        map! ]o \overline{
autocmd BufRead *.tex        map! ]u \underline{
autocmd BufRead *.tex        map! ]bf {\bf 

" set # to toggle line numbers on and off:
map \o# o:se nu<CR>:se nonu<esc>-:map \o# "wp<CR>
map \d# "w2dd
map \x# "xdd@x"xpk
map # ma3L\o#\x#\d#`a:<CR>

" If buffer modified, update any 'Last modified: ' in the first 20 lines.
" " 'Last modified: Tue May 26, 2009  06:44PM
" " Restores position using s mark.
function! LastModified()
        if &modified
                normal ms
                let n = min([20, line("$")])
                exe '1,' . n . 's#^\(.\{,10}Last modified: \).*#\1' .
                \ strftime('%c') . '#e'
                normal `s
        endif
endfun
autocmd BufWritePre * call LastModified()

" From: ~/.vim/colors/ir_black.vim
colorscheme ir_black
set background=light
set background=dark
if version >= 700 " Vim 7.x specific colors
  hi Search         guifg=NONE        guibg=NONE        gui=underline ctermfg=black       ctermbg=yellow      cterm=NONE
endif

"hi clear SpellBad
hi SpellBad cterm=underline ctermfg=red ctermbg=none
hi SpellRare cterm=underline ctermfg=green ctermbg=none
hi SpellLocal cterm=underline ctermfg=green ctermbg=none


"
" We must be able to show the 80 column limit with F9...
" Hitting F9 again will toggle back to normal.
"
function! Column80 ()
    if exists('+colorcolumn')
        " Show column 80
        if &colorcolumn == ""
            set colorcolumn=80
        else
            set colorcolumn=
        endif
    endif
endfunction

noremap  <silent> <F9> :call Column80()<CR>
noremap! <silent> <F9> <ESC> :call Column80()<CR>

"
" Manpage for word under cursor via 'K' in command mode
"
runtime! ftplugin/man.vim
noremap <buffer> <silent> K :exe "Man" expand('<cword>') <CR>

" vim:tw=76:ts=4:sw=2
