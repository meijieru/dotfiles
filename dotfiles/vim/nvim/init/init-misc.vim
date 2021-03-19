" {{{ Others 

" set up preview
" https://stackoverflow.com/questions/3712725/can-i-change-vim-completion-preview-window-height
set previewheight=10
function! s:PreviewHeightWorkAround()
    if &previewwindow
        exec 'setlocal winheight='.&previewheight
    endif
endfunction

let s:set_preview_height = get(g:, 'set_preview_height', 0)
if s:set_preview_height
    augroup set_preview
        autocmd!
        autocmd InsertLeave * if pumvisible() == 0|pclose|endif
        autocmd BufEnter ?* call s:PreviewHeightWorkAround()
    augroup end
endif

" auto jump to last modified position
augroup aux
    autocmd!
    autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
augroup end

" better diff algorithm
if has('nvim') || has("patch-8.1.0360")
    set diffopt+=internal,algorithm:patience
endif

if has('nvim')
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    autocmd VimLeave * set guicursor=a:block-blinkon0
end

" }}} Others 
