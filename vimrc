" Vim

"Use pathogen to load plugins in '~/.vim/bundles'
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

set incsearch
set laststatus=2
set tabstop=4
set shiftwidth=4
set softtabstop=0
set noexpandtab
let &showbreak = '+++ '
set nocompatible        " Use Vim defaults (much better!)
set t_Co=16
set bs=2                " allow backspacing over everything in insert mode
set backup              " keep a backup file
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

" Convert each <TAB> in a selection to 4 <SPACE>s.
map ,ts :s/\t/    /g<CR>:noh<CR>

function ComputeVer(verstring)
	"  exe "let g:" . a:verstring . " = ". v:version/ 100
	let g:verstring = v:version/100
	let g:verstring = g:verstring.".".(v:version - g:verstring*100)
endfunction


command DiffOrig new|set bt=nofile|r #|0d_|diffthis|wincmd p|diffthis

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

" Go to next misspelled word
map <F2> ]s
" Suggestions for misspelled word
map <F3> z=


" Resize current window to 80 width
noremap  <silent> w80 :vertical resize 80

" Increase/Decrease horizontally split window
" noremap _ :resize +1<CR>
" noremap - :resize -1<CR>
" Increase/Decrease vertically split window
" noremap _ :vertical resize +1<CR>
"noremap - :vertical resize -1<CR>

"
" Manpage for word under cursor via 'K' in command mode
"
runtime! ftplugin/man.vim
noremap <buffer> <silent> K :exe "Man" expand('<cword>') <CR>

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
" The next few lines are from:
" http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
set completeopt=menuone,longest,preview
"inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
"  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" <C-@> is Control-Space in vim on a terminal.
"inoremap <expr> <C-@> pumvisible() ? '<C-n>' :
"  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
set pumheight=7
set splitbelow

" For plugin/ctab.vim
let g:ctab_filetype_maps = 1
let g:ctab_enable_default_filetype_maps = 1

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
" ❰❱❮❯❭❬❨❩❪❫⎨⎬ β
let g:airline_left_sep = '⎬'
let g:airline_right_sep = '⎨'
let g:airline_symbols.crypt = 'c'
let g:airline_symbols.linenr = ''
let g:airline_symbols.branch = 'β'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" vim:tw=76:ts=4:sw=4
