if exists("b:did_gitcommitplugin")
  finish
endif

let b:did_gitcommitplugin = 1 " Don't load twice in one buffer

setlocal spell
