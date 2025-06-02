" set colorscheme
syntax on
set background=dark

set autoindent
au BufNewFile,BufRead *.eyaml,*.yaml,*.yml so ~/.vim/yaml.vim

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

set pastetoggle=<F2>

" for python
filetype indent plugin on
set tabstop=8 expandtab shiftwidth=4 softtabstop=4
