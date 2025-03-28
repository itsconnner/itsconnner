call plug#begin('~/.vim/plugged')
Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

if !isdirectory(expand('~/.vim/swap'))
	call mkdir(expand('~/.vim/swap'), 'p')
endif

set directory=~/.vim/swap

set number
set tabstop=8
set autoindent
set shiftwidth=8
set cindent
set backspace=indent,eol,start
set ruler

colorscheme barroit
