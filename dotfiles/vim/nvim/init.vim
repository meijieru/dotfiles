let g:mapleader = ' '
let g:maplocalleader = ' '

" global var
let g:root_markers = ['.svn', '.git', '.root', '.project', '.env', '.vim'] 
let g:runtime_root = expand('~/.local/share/nvim/site/')

let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
if !exists(':LoadScript')
 command! -nargs=1 LoadScript exec 'so ' . s:home . '/' . '<args>'
endif

" speed up startup
" $ANACONDA_HOME should be set in shell
if has('nvim')
    if strlen($ANACONDA_HOME) ==# 0
        let g:python_host_prog = '/usr/bin/python2'
        let g:python3_host_prog = '/usr/bin/python3'
    else
        let g:python_host_prog = $ANACONDA_HOME . '/bin/python2'
        let g:python3_host_prog = $ANACONDA_HOME . '/bin/python3'
    endif
endif

" install plugins
let g:bundle_groups = ['simple', 'basic', 'high', 'ale', 'coc', 'vcs', 'airline', 'auxlib', 'vimspector']
LoadScript init/init-plugins.vim

LoadScript init/init-basic.vim
LoadScript init/init-display.vim
LoadScript init/init-encoding.vim
LoadScript init/init-misc.vim
LoadScript init/init-keymaps.vim
LoadScript init/init-filetypes.vim
