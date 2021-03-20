" TODO(meijieru): coc reference using floating window

let g:coc_global_extensions = [
            \ 'coc-pyright',
            \ 'coc-vimlsp',
            \ 'coc-vimtex',
            \ 'coc-highlight',
            \ 'coc-json',
            \ 'coc-yaml',
            \ 'coc-ultisnips',
            \ ]

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
let g:airline#extensions#coc#enabled = 0

nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gy <Plug>(coc-type-definition)
nmap <silent>gi <Plug>(coc-implementation)
nmap <silent>gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf  <Plug>(coc-fix-current)
" nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
" nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
inoremap <silent><expr> <c-space> coc#refresh()

function! s:my_custom_cr() abort
    " ref https://github.com/neoclide/coc.nvim/issues/262#issuecomment-792331399
    if !exists('*complete_info')
        throw 'select_enter requires complete_info function to work'
    endif
    let selected = complete_info()['selected']
    if pumvisible()
        if selected == -1
            " no item selected, just enter a linebreak
            return "\<C-y>\<CR>"
        else
            " confirm the selected item
            return "\<C-y>"
        endif
    else
        return "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"
    endif
endfunction
inoremap <expr> <Plug>CustomCocCR <SID>my_custom_cr()
imap <CR> <Plug>CustomCocCR

" Use K for show documentation in preview window
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

augroup coc
    " no folding for hover
    autocmd User CocOpenFloat :setl foldlevel=20 foldcolumn=0
    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * if exists('*CocActionAsync') | call CocActionAsync('highlight') | endif
augroup end

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap for format selected region
" vmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)
