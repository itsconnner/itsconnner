call plug#begin('~/.vim/plugged')
" List your plugins here
Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

if !isdirectory(expand('~/.vim/swap'))
	silent !mkdir -p ~/.vim/swap
endif

set directory=~/.vim/swap//	" swap folder

set number			" Show line numbers
set tabstop=8
set autoindent
set shiftwidth=8
set cindent			" C/C++ indentation
set backspace=indent,eol,start	" backspace behavior

colorscheme barroit
