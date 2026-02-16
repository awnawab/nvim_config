" Load Fortran syntax first
runtime! syntax/fortran.vim

" Add fypp-specific highlighting
syn match fyppDirective /^#:.*/
syn match fyppVariable /\${\w\+}/
syn match fyppComment /^#!.*/

" Define highlighting
hi def link fyppDirective PreProc
hi def link fyppVariable Identifier  
hi def link fyppComment Comment
