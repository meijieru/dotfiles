" {{{ FileType Settings

augroup filetype_specify
    autocmd!
    autocmd filetype python setlocal tabstop=4 shiftwidth=4 expandtab ai
    autocmd filetype cuda setlocal ft=cuda.cpp
    autocmd filetype plaintex,latex setlocal ft=tex
    autocmd filetype tex,text setlocal wrap
    autocmd filetype markdown setlocal tabstop=4 shiftwidth=4 expandtab wrap
    autocmd filetype cpp,c setlocal nowrap commentstring=//\ %s
augroup end

" }}} FileType Settings

