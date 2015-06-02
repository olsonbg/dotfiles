" Vim syntax file
" Language:	BTCL
" Maintainer:	Brett Cannon <brett@python.org>
" 		(previously Dean Copsey <copsey@cs.ucdavis.edu>)
"		(previously Matt Neumann <mattneu@purpleturtle.com>)
"		(previously Allan Kelly <allan@fruitloaf.co.uk>)
" Original:	Robin Becker <robin@jessikat.demon.co.uk>
" Last Change:	2006 Nov 17
"
" Keywords TODO: format clock click anchor

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" A bunch of useful keywords
syn keyword btclStatement  tell socket subst open eof pwd glob list exec pid
syn keyword btclStatement  auto_load_index time unknown eval lrange fblocked
syn keyword btclStatement  lsearch auto_import gets lappend proc variable llength
syn keyword btclStatement  auto_execok return linsert error catch clock info
syn keyword btclStatement  split array fconfigure concat join lreplace source
syn keyword btclStatement  fcopy global auto_qualify update close cd auto_load
syn keyword btclStatement  file append format read package set binary namespace
syn keyword btclStatement  scan trace seek flush after vwait uplevel lset rename
syn keyword btclStatement  fileevent regexp upvar unset encoding expr load regsub
syn keyword btclStatement interp exit puts incr lindex lsort tclLog string
syn keyword btclLabel		case default
syn keyword btclConditional	if then else elseif switch
syn keyword btclRepeat		while for foreach break continue

" For BTCL
syn keyword btclAccelrysStatement	forcefield minimize dynamics vdWTailCorrection
syn keyword btclAccelrysStatement	writeFile readFile command print echo
syn keyword btclAccelrysStatement	peek
syn keyword btclAccelrysRepeat		execute
syn keyword btclAccelrysType		timestep initial_temperature ensemble
syn keyword btclAccelrysType		temperature_control_method
syn keyword btclAccelrysType		decay_constant temperature deviation
syn keyword btclAccelrysType		press_choice press_decay_constant
syn keyword btclAccelrysType		pressure_control_method q_ratio
syn keyword btclAccelrysType		frequency first_step last_step
syn keyword btclAccelrysType		table filename
syn keyword btclAccelrysType		average average batch_average batch_sd batch_size
syn keyword btclAccelrysType		total_energy kinetic_energy potential_energy
syn keyword btclAccelrysType		pressure volume density derivative
syn keyword btclAccelrysType		before after
syn keyword btclAccelrysType		method final_convergence
syn keyword btclAccelrysType		iteration_limit convergence
syn keyword btclAccelrysType		line_search_precision sd cg newton
syn keyword btclAccelrysType		archive frame
syn keyword btclAccelrysType		separate_coulomb vdw summation_method
syn keyword btclAccelrysType		cutoff spline_width buffer_width
syn keyword btclAccelrysType		coulomb dielectric_value
syn keyword btclAccelrysType		ewald_accuracy update_width



" variable reference
	" ::optional::namespaces
syn match btclVarRef "$\(\(::\)\?\([[:alnum:]_.]*::\)*\)\a[a-zA-Z0-9_.]*"
	" ${...} may contain any character except '}'
syn match btclVarRef "${[^}]*}"
syn keyword btclVarRef                  NVE NPT NVT nose berendsen_pc
syn keyword btclVarRef                  ewald atom_based
syn keyword btclTodo contained	TODO


" String and Character contstants
" Highlight special characters (those which have a backslash) differently
syn match   btclSpecial contained "\\\d\d\d\=\|\\."
" A string needs the skip argument as it may legitimately contain \".
" Match at start of line
syn region  btclString		  start=+^"+ end=+"+ contains=tclSpecial skip=+\\\\\|\\"+
"Match all other legal strings.
syn region  btclString		  start=+[^\\]"+ms=s+1  end=+"+ contains=tclSpecial skip=+\\\\\|\\"+

syn match   btclLineContinue "\\\s*$"

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match  btclNumber		"\<\d\+\(u\=l\=\|lu\|f\)\>"
"floating point number, with dot, optional exponent
syn match  btclNumber		"\<\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, starting with a dot, optional exponent
syn match  btclNumber		"\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match  btclNumber		"\<\d\+e[-+]\=\d\+[fl]\=\>"
"hex number
syn match  btclNumber		"0x[0-9a-f]\+\(u\=l\=\|lu\)\>"
"syn match  tclIdentifier	"\<[a-z_][a-z0-9_]*\>"
syn case match

syn region  btclComment		start="^\s*\#" skip="\\$" end="$" contains=tclTodo
syn region  btclComment		start=/;\s*\#/hs=s+1 skip="\\$" end="$" contains=tclTodo

"syn sync ccomment tclComment

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_btcl_syntax_inits")
  if version < 508
    let did_btcl_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink btclLabel		Label
  HiLink btclConditional	Conditional
  HiLink btclRepeat		Repeat
  HiLink btclNumber		Number
  HiLink btclError		Error
  HiLink btclStatement		Statement
  "HiLink btclStatementColor	Statement
  HiLink btclString		String
  HiLink btclComment		Comment
  HiLink btclSpecial		Special
  HiLink btclTodo		Todo
  " Below here are the commands and their options.
  "HiLink btcltkLsort		Statement
  HiLink btclVarRef		Identifier
  HiLink btclAccelrysStatement	Statement
  HiLink btclAccelrysRepeat	Repeat
  HiLink btclAccelrysType	Type

  delcommand HiLink
endif

let b:current_syntax = "btcl"
let b:commentstring = "#%s"

" vim: ts=8
