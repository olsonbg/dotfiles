setlocal textwidth=76
setlocal spell spelllang=en_us
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

map  <buffer> Q :call TeX_par()<CR>
map! <buffer> ]i \item
map! <buffer> ]bi \begin{itemize}
map! <buffer> ]ei \end{itemize}
map! <buffer> ]be \begin{enumerate}
map! <buffer> ]ee \end{enumerate}
map! <buffer> ]bd \begin{description}
map! <buffer> ]ed \end{description}
map! <buffer> ]bc \begin{center}
map! <buffer> ]ec \end{center}
map! <buffer> [be {\samepage\begin{eqnarray}
map! <buffer> [ee \end{eqnarray}}
map! <buffer> ]s1 \section{
map! <buffer> ]s2 \subsection{
map! <buffer> ]s3 \subsubsection{
map! <buffer> ]p1 \paragraph{
map! <buffer> ]p2 \subparagraph{
map! <buffer> ]f \frac{
map! <buffer> ]o \overline{
map! <buffer> ]u \underline{
map! <buffer> ]bf {\bf

