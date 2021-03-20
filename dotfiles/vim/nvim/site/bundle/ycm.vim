let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_key_list_select_completion=['<c-n>']
let g:ycm_key_list_previous_completion=['<c-p>']
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_use_ultisnips_completer = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_show_diagnostics_ui = 0
let g:ycm_always_populate_location_list = 1

let g:ycm_add_preview_to_completeopt = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_goto_buffer_command = 'vertical-split'
let g:ycm_error_symbol = '✗'
let g:ycm_python_binary_path = g:python3_host_prog

" command alias for youcompleteme
nnoremap <leader>gi :YcmCompleter GoToInclude<CR>
nnoremap <leader>gdf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gdc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gr :YcmCompleter GoToReferences<CR>
nnoremap <leader>fi :YcmCompleter FixIt<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gdo :YcmCompleter GetDoc<CR>

let g:ycm_filetype_blacklist = {
            \ 'tagbar' : 1,
            \ 'gitcommit' : 1, }
let g:ycm_semantic_triggers =  {
            \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
            \ 'cs,lua,javascript,tex': ['re!\w{2}'], }
