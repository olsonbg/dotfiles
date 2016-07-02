" my filetype file
if exists("did_load_filetypes")
	finish
endif

augroup filetypedetect
au   BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
au!  BufNewFile,BufReadPost *.m       setfiletype octave
au!  BufNewFile,BufReadPost *res2     setfiletype patfit
au!  BufNewFile,BufReadPost *cont2    setfiletype patfit
au!  BufNewFile,BufReadPost *res-foot setfiletype patfit
au!  BufNewFile,BufReadPost *pos-foot setfiletype patfit
au!  BufNewFile,BufReadPost *.inp     setfiletype btcl
au!  BufNewFile,BufReadPost *.lmp     setfiletype lammps
augroup END
