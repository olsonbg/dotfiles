" Vim syntax file
" Language:	Octave
" Maintainer:	Bill Lash <lash@tellabs.com>
"		Based on "matlab.vim" by Preben "Peppe" Guldberg and Mario Eusebio
"		and "octave-mod.el" by Kurt Hornik and John Eaton
" Last change:	Mon Mar  2 18:29:22 CST 1998

" Remove any old syntax stuff hanging around
syn clear


syn keyword octaveBeginKeywords for function if switch try unwind_protect while

syn keyword octaveElseKeywords case catch else elseif otherwise unwind_protect_cleanup

syn keyword octaveEndKeywords  end endfor endfunction endif endswitch end_try_catch
syn keyword octaveEndKeywords  end_unwind_protect endwhile

syn keyword octaveReserved     all_va_args break continue global gplot gsplot
syn keyword octaveReserved     replot return 

syn keyword octaveTextFuncs    casesen cd chdir clear diary dir document echo
syn keyword octaveTextFuncs    edit_history format gset gshow help history hold
syn keyword octaveTextFuncs    load ls more run_history save set show type
syn keyword octaveTextFuncs    which who whos eval

syn keyword octaveVariables    EDITOR EXEC_PATH F_DUPFD F_GETFD F_GETFL F_SETFD
syn keyword octaveVariables    F_SETFL I IMAGEPATH INFO_FILE INFO_PROGRAM Inf J
syn keyword octaveVariables    LOADPATH NaN OCTAVE_VERSION O_APPEND O_CREAT O_EXCL
syn keyword octaveVariables    O_NONBLOCK O_RDONLY O_RDWR O_TRUNC O_WRONLY PAGER PS1
syn keyword octaveVariables    PS2 PS4 PWD SEEK_CUR SEEK_END SEEK_SET __F_DUPFD__
syn keyword octaveVariables    __F_GETFD__ __F_GETFL__ __F_SETFD__ __F_SETFL__ __I__
syn keyword octaveVariables    __Inf__ __J__ __NaN__ __OCTAVE_VERSION__ __O_APPEND__
syn keyword octaveVariables    __O_CREAT__ __O_EXCL__ __O_NONBLOCK__ __O_RDONLY__
syn keyword octaveVariables    __O_RDWR__ __O_TRUNC__ __O_WRONLY__ __PWD__ __SEEK_CUR__
syn keyword octaveVariables    __SEEK_END__ __SEEK_SET__ __argv__ __e__ __eps__
syn keyword octaveVariables    __error_text__ __i__ __inf__ __j__ __nan__ __pi__
syn keyword octaveVariables    __program_invocation_name__ __program_name__ __realmax__
syn keyword octaveVariables    __realmin__ __stderr__ __stdin__ __stdout__ ans argv
syn keyword octaveVariables    automatic_replot beep_on_error completion_append_char
syn keyword octaveVariables    default_return_value default_save_format
syn keyword octaveVariables    define_all_return_values do_fortran_indexing e
syn keyword octaveVariables    echo_executing_commands empty_list_elements_ok eps
syn keyword octaveVariables    error_text gnuplot_binary gnuplot_has_multiplot history_file
syn keyword octaveVariables    history_size ignore_function_time_stamp implicit_str_to_num_ok
syn keyword octaveVariables    inf nan nargin ok_to_lose_imaginary_part
syn keyword octaveVariables    output_max_field_width output_precision
syn keyword octaveVariables    page_output_immediately page_screen_output pi
syn keyword octaveVariables    prefer_column_vectors prefer_zero_one_indexing
syn keyword octaveVariables    print_answer_id_name print_empty_dimensions
syn keyword octaveVariables    program_invocation_name program_name propagate_empty_matrices
syn keyword octaveVariables    realmax realmin resize_on_range_error
syn keyword octaveVariables    return_last_computed_value save_precision saving_history
syn keyword octaveVariables    silent_functions split_long_rows stderr stdin stdout
syn keyword octaveVariables    string_fill_char struct_levels_to_print
syn keyword octaveVariables    suppress_verbose_help_message treat_neg_dim_as_zero
syn keyword octaveVariables    warn_assign_as_truth_value warn_comma_in_global_decl
syn keyword octaveVariables    warn_divide_by_zero warn_function_name_clash
syn keyword octaveVariables    warn_missing_semicolon whitespace_in_literal_matrix
  
syn keyword octaveTodo 			contained  TODO

" If you do not want these operators lit, uncommment them and the "hi link" below
syn match octaveLogicalOperator    	"[&|~!]"
syn match octaveArithmeticOperator	"[-+]"
syn match octaveArithmeticOperator	"\.\=[*/\\^]"
syn match octaveRelationalOperator	"[=!~]="
syn match octaveRelationalOperator	"[<>]=\="

syn match octaveLineContinuation	"\.\.\."
syn match octaveLineContinuation	"\\[ \t]*[#%]"me=e-1 
syn match octaveLineContinuation	"\\[ \t]*$" 

"syn match octaveIdentifier		"\<[a-zA-Z_][a-zA-Z0-9_]*\>"

" String
syn region octaveString			start=+'+ end=+'+	oneline
syn region octaveString			start=+"+ end=+"+	oneline

" If you don't like tabs
syn match octaveTab			"\t"

" Standard numbers
syn match octaveNumber		"\<[0-9]\+[ij]\=\>"
" floating point number, with dot, optional exponent
syn match octaveFloat		"\<[0-9]\+\.[0-9]*\([edED][-+]\=[0-9]\+\)\=[ij]\=\>"
" floating point number, starting with a dot, optional exponent
syn match octaveFloat		"\.[0-9]\+\([edED][-+]\=[0-9]\+\)\=[ij]\=\>"
" floating point number, without dot, with exponent
syn match octaveFloat		"\<[0-9]\+[edED][-+]\=[0-9]\+[ij]\=\>"

" Transpose character and delimiters: Either use just [...] or (...) aswell
"syn match octaveDelimiter		"[][]"
syn match  octaveDelimiter		"[][()]"
syn match octaveTransposeOperator	"[])a-zA-Z0-9]'"lc=1
syn match octaveTransposeOperator	"\.'"

syn match octaveComment		"%.*$"	contains=octaveTodo,octaveTab
syn match octaveComment		"#.*$"	contains=octaveTodo,octaveTab


syn match octaveError	"-\=\<[0-9]\+\.[0-9]\+\.[^*/\\^]"
syn match octaveError	"-\=\<[0-9]\+\.[0-9]\+[eEdD][-+]\=[0-9]\+\.\([^*/\\^]\)"

if !exists("did_octave_syntax_inits")
  let did_octave_syntax_inits = 1
  " The default methods for highlighting.  Can be overridden later
  hi link octaveBeginKeywords		Conditional
  hi link octaveElseKeywords		Conditional
  hi link octaveEndKeywords		Conditional
  hi link octaveTextFuncs		Function
  hi link octaveReserved		Statement
  hi link octaveVariables		Identifier

  hi link octaveTodo			Todo
  hi link octaveNumber			Number
  hi link octaveFloat			Float
  hi link octaveString			String
  hi link octaveDelimiter		Identifier
  hi link octaveLineContinuation	Special
  hi link octaveError			Error
  hi link octaveComment			Comment

  hi link octaveArithmeticOperator	octaveOperator
  hi link octaveRelationalOperator	octaveOperator
  hi link octaveLogicalOperator		octaveOperator
  hi link octaveTransposeOperator	octaveOperator
  hi link octaveOperator		Operator

"optional highlighting
  "hi link octaveIdentifier		Identifier
  "hi link octaveTab			Error
endif

let b:current_syntax = "octave"

"EOF	vim: ts=8 noet tw=100 sw=8 sts=0
