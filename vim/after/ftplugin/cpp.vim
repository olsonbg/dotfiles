" Recommended for smart tabs plugin
setlocal noexpandtab
setlocal softtabstop=0
setlocal shiftwidth=4
setlocal tabstop=4
setlocal cindent
setlocal cinoptions=(0,u0,U0
" End recommended

setlocal copyindent
setlocal autoindent
setlocal formatoptions=tcqr

setlocal spell spelllang=en_us


" For matching \todo statement in doxygen markups
syn match MyTodo /\v\\todo/ containedin=.*Comment,vimCommentTitle
hi def link myTodo Todo


" OmniCppComplete
setlocal omnifunc=omni#cpp#complete#Main
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

setlocal tags+=~/Projects/tags/tags-core
setlocal tags+=~/Projects/tags/tags-base
"setlocal tags+=~/Projects/tags/tags-extras
"setlocal tags+=~/Projects/tags/tags-boost

call SuperTabSetDefaultCompletionType("<c-x><c-o>")
