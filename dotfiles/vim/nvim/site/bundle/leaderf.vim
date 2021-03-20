" LeaderF
let g:Lf_ShortcutF = '<leader>ff'
let g:Lf_ShortcutB = '<leader>fb'
nnoremap <leader>fm :Leaderf mru<cr>
nnoremap <leader>fc :Leaderf! function<cr>
nnoremap <leader>fl :Leaderf! bufTag<cr>
" nnoremap <leader>ft :Leaderf tag<cr>
nnoremap <leader>fs :Leaderf searchHistory<cr>
nnoremap <leader>fh :Leaderf cmdHistory<cr>
nnoremap <leader>fp :Leaderf --recall<cr>
nnoremap <leader>fgc :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
nnoremap <leader>fge :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
nnoremap <leader>fgp :<C-U>Leaderf! rg --recall<CR>
xnoremap <leader>fge :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
nnoremap <leader>ft :<C-U>Leaderf! --nowrap task<CR>
inoremap <c-x><c-j> <c-\><c-o>:Leaderf snippet<cr>

let g:Lf_RootMarkers = g:root_markers
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_DefaultMode = 'NameOnly'
let g:Lf_WindowHeight = 0.35
let g:Lf_CacheDirectory = g:runtime_root . 'cache'
let g:Lf_StlColorscheme = 'gruvbox'
let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_PreviewResult = {'Function':1, 'BufTag':0, 'snippet': 1}
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_PreviewInPopup = 1
let g:Lf_WindowPosition = 'popup'
let g:Lf_PopupColorscheme = 'default'
let g:Lf_ShowDevIcons = 1
let g:Lf_Extensions = get(g:, 'Lf_Extensions', {})
let g:Lf_Extensions.task = {
            \ 'source': string(function('leaderf#asynctasks#lf_task_source'))[10:-3],
            \ 'accept': string(function('leaderf#asynctasks#lf_task_accept'))[10:-3],
            \ 'get_digest': string(function('leaderf#asynctasks#lf_task_digest'))[10:-3],
            \ 'highlights_def': {
            \     'Lf_hl_funcScope': '^\S\+',
            \     'Lf_hl_funcDirname': '^\S\+\s*\zs<.*>\ze\s*:',
            \ },
            \ }
" let g:Lf_NormalMap = {
"             \ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
"             \ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
"             \ "Mru": [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
"             \ "Tag": [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
"             \ "BufTag": [["<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
"             \ "Function": [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
"             \ "Rg": [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
"             \ }
