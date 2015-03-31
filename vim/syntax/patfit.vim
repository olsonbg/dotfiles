" Vim syntax file
" Language:	patfit

" Remove any old syntax stuff hanging around
syn clear

syn match patfitGuessFixed	"G"
syn match patfitGuessFixed	"F"

syn match patfitComponents      "         [0-9]"

" Standard numbers
syn match patfitNumber		"\<[0-9]\+[ij]\=\>"
" floating point number, with dot, optional exponent
syn match patfitFloat		"\<[0-9]\+\.[0-9]*\([edED][-+]\=[0-9]\+\)\=[ij]\=\>"
" floating point number, starting with a dot, optional exponent
syn match patfitFloat		"\.[0-9]\+\([edED][-+]\=[0-9]\+\)\=[ij]\=\>"
" floating point number, without dot, with exponent
syn match patfitFloat		"\<[0-9]\+[edED][-+]\=[0-9]\+[ij]\=\>"

syn match patfitComment		"POSITRONFIT.*$"
syn match patfitComment		"DATA BLOCK:.*$"
syn match patfitComment		"RESOLUTION DATA BLOCK:.*$"
syn match patfitComment		"LIFETIMES.*$"
syn match patfitComment		"BACKGROUND.*$"

if !exists("did_patfit_syntax_inits")
  let did_patfit_syntax_inits = 1
  " The default methods for highlighting.  Can be overridden later
  hi link patfitNumber			Number
  hi link patfitFloat			Number
  hi link patfitGuessFixed		Conditional
  hi link patfitComponents		Special
  hi link patfitComment			Comment
endif

let b:current_syntax = "patfit"

"EOF	vim: ts=8 noet tw=100 sw=8 sts=0
