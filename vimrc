" Vim

"Use pathogen to load plugins in '~/.vim/bundles'
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

set incsearch
set formatoptions=tcqr
set cinoptions=(0,u0,U0
set laststatus=2
set tabstop=4
set shiftwidth=4
set softtabstop=0
set noexpandtab
set showbreak=\ \ \ \ \ \
set nocompatible        " Use Vim defaults (much better!)
set t_Co=16
set bs=2                " allow backspacing over everything in insert mode
set backup              " keep a backup file
set viminfo='20,\"50    " read/write a .viminfo file, don't store more
                        " than 50 lines of registers
set showcmd
set whichwrap=b,s,<,>,[,]
set printoptions=paper:letter
set listchars=tab:>-,trail:-
set list
" The next two allow italics
set t_ZH=[3m
set t_ZR=[23m
filetype plugin indent on
" NERD Commenter
let NERDShutUp      = 1   " Don't warn on unsupported filetype
let NERDSpaceDelims = 1   " Put a space between comment delimiter and text
let mapleader       = ',' " Use , as leader for NERD commands


" Enable Vim 7+ spell checking
au BufRead *.tex setlocal spell spelllang=en_us
au BufRead *.txt setlocal spell spelllang=en_us
au BufRead *.md  setlocal spell spelllang=en_us

" Go to next misspelled word
map <F2> ]s
" Suggestions for misspelled word
map <F3> z=
" Convert each <TAB> in a selection to 4 <SPACE>s.
map ,ts :s/\t/    /g<CR>:noh<CR>

" In text files, always limit the width of text to 76 characters
autocmd BufRead *.txt set tw=76
autocmd BufRead *.tex set tw=76
autocmd BufRead *.md  set tw=76
"autocmd BufRead *.html      set filetype=php
"autocmd BufRead *.php       set filetype=php
"autocmd BufRead *.inc       set filetype=php

function ComputeVer(verstring)
"  exe "let g:" . a:verstring . " = ". v:version/ 100
  let g:verstring = v:version/100
  let g:verstring = g:verstring.".".(v:version - g:verstring*100)
endfunction

command DiffOrig new|set bt=nofile|r #|0d_|diffthis|wincmd p|diffthis

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

"
" Custom keymaps
"
" set # to toggle line numbers on and off:
map # :set invnumber<CR>

" maps NERDTree to F10
" (normal, visual and operator-pending modes)
noremap <silent> <F10> :NERDTreeToggle<CR>:vert resize 25<CR>
" (also in insert and command-line modes)
noremap! <silent> <F10> <ESC>:NERDTreeToggle<CR>:vert resize 25<CR>

" maps Tagbar to F11
noremap <silent> <F11> :TagbarToggle<CR>
noremap! <silent> <F11> <ESC>:TagbarToggle<CR>

" maps highlighting column 80 to <F9>
noremap  <silent> <F9> :call Column80()<CR>
noremap! <silent> <F9> <ESC> :call Column80()<CR>

" Resize current window to 80 width
noremap  <silent> w80 :vertical resize 80

" Increase/Decrease horizontally split window
" noremap _ :resize +1<CR>
" noremap - :resize -1<CR>
" Increase/Decrease vertically split window
" noremap _ :vertical resize +1<CR>
"noremap - :vertical resize -1<CR>

set tags+=~/Projects/tags/tags-core
set tags+=~/Projects/tags/tags-base
"set tags+=~/Projects/tags/tags-extras
"set tags+=~/Projects/tags/tags-boost
"
" Manpage for word under cursor via 'K' in command mode
"
runtime! ftplugin/man.vim
noremap <buffer> <silent> K :exe "Man" expand('<cword>') <CR>

" OmniCppComplete
au BufNewFile,BufRead,BufEnter *.cpp,*.h set omnifunc=omni#cpp#complete#Main
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"set completeopt=menuone,menu,longest,preview
" The next few lines are from:
" http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
set completeopt=menuone,longest,preview
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" <C-@> is Control-Space in vim on a terminal.
inoremap <expr> <C-@> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

let g:solarized_visibility="normal"
colorscheme solarized

"
" vim-airline settings
"
let g:airline#extensions#whitespace#mixed_indent_algo = 2

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

" unicode symbols
" ❰❱❮❯❭❬❨❩❪❫⎨⎬
let g:airline_left_sep = '⎬'
let g:airline_right_sep = '⎨'
let g:airline_symbols.crypt = 'c'
let g:airline_symbols.linenr = ''
let g:airline_symbols.branch = '⅄'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" vim:tw=76:ts=4:sw=4
