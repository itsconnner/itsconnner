" vim config for barroit
" $HOME/

call plug#begin('~/.vim/plugged')
" List your plugins here
Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

set number						" Show line numbers
set tabstop=4					" Set tab width to 4 spaces
set autoindent					" Auto-indent new lines
set shiftwidth=4				" Set shift width to 4 spaces
set cindent						" C/C++ indentation
set backspace=indent,eol,start	" Maintain backspace behavior

colorscheme barroit				" Set Color Scheme
