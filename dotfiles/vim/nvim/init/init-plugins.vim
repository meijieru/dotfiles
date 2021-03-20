scriptencoding utf-8

" TODO(meijieru):
" 1. `~` for returning to project root
" config terminal
" optimize key mapping
" config linuxbrew

" Install vim-plug if we don't already have it
if empty(glob(g:runtime_root . 'autoload/plug.vim'))
    " Ensure all needed directories exist  (Thanks @kapadiamush)
    for s:dir in [ 'plugged', 'autoload', 'files/backup', 'files/info', 'files/swap', 'files/undo', 'cache/tags', 'log']
        execute '!mkdir -p ' . g:runtime_root . s:dir
    endfor
    " Download the actual plugin manag'er
    execute '!curl -fLo ' . g:runtime_root . 'autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin(g:runtime_root . 'plugged')

" {{{ bundle group: simple
if index(g:bundle_groups, 'simple') >= 0
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-sleuth'
    Plug 'tpope/vim-rsi'
    if auxlib#utils#is_unix()
        Plug 'tpope/vim-eunuch'
    endif
    Plug 'bronson/vim-visual-star-search'

    Plug 'soft-aesthetic/soft-era-vim'
    Plug 'morhetz/gruvbox'
    Plug 'mhartington/oceanic-next'
    Plug 'joshdick/onedark.vim'

    Plug 'jiangmiao/auto-pairs'
    Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
    Plug 'easymotion/vim-easymotion'
    Plug 'luochen1990/rainbow'
    Plug 'Yggdroot/indentLine'

    " colorscheme
    let s:colorscheme_italic = 0
    let g:gruvbox_italic = s:colorscheme_italic
    let g:gruvbox_improved_warnings = 1
    let g:oceanic_next_terminal_bold = 1
    let g:oceanic_next_terminal_italic = s:colorscheme_italic
    let g:onedark_terminal_italics = s:colorscheme_italic

    " auto-pairs
    let g:AutoPairsMapCh = 0 " Interfere with <left>
    " TODO(meijieru): fix compat with my_custom_cr()
    let g:AutoPairsMapCR = 0
    augroup auto_pair_clean
        autocmd!
        autocmd VimEnter,BufEnter,BufWinEnter * silent! iunmap <buffer> <M-">
    augroup end

    " tabular
    nnoremap <leader>a= :Tabularize /=<CR>
    vnoremap <leader>a= :Tabularize /=<CR>
    nnoremap <leader>a/ :Tabularize /\/\//l2c1l0<CR>
    vnoremap <leader>a/ :Tabularize /\/\//l2c1l0<CR>
    nnoremap <leader>a, :Tabularize /,/l0r1<CR>
    vnoremap <leader>a, :Tabularize /,/l0r1<CR>
    nnoremap <leader>al :Tabularize /\|<cr>
    vnoremap <leader>al :Tabularize /\|<cr>
    nnoremap <leader>ar :Tabularize /\|/r1<cr>
    vnoremap <leader>ar :Tabularize /\|/r1<cr>

    " easymotion
    let g:EasyMotion_smartcase = 1
    map <Leader><leader>. <Plug>(easymotion-repeat)
    map <Leader><leader>s <Plug>(easymotion-sn)

    " rainbow for pairs
    let g:rainbow_active=1

    " indentline
    let g:tex_conceal=''    " compatible with latex
    let g:indentLine_concealcursor=0  " work with cursorline
endif
" }}} bundle group: simple

" {{{ bundle group: basic
if index(g:bundle_groups, 'basic') >= 0
    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
    Plug 'skywind3000/Leaderf-snippet'
    LoadScript site/bundle/leaderf.vim

    Plug 'mhinz/vim-startify'
    Plug 'machakann/vim-highlightedyank'

    Plug 'mg979/vim-visual-multi', { 'branch': 'master' }
    Plug 'skywind3000/vim-terminal-help'
    Plug 'skywind3000/asynctasks.vim'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

    Plug 'tbastos/vim-lua', { 'for': 'lua' }
    Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
    Plug 'vim-python/python-syntax', { 'for': ['python'] }
    Plug 'dccmx/google-style.vim', { 'for': ['c', 'cpp', 'python'] }
    Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
    Plug 'stephpy/vim-yaml', { 'for': 'yaml' }
    Plug 'cespare/vim-toml', { 'for': 'toml' }

    " startify
    let g:startify_change_to_dir = 0

    " vim-which-key
    let g:which_key_use_floating_win = 1
    let g:which_key_timeout = 300
    " let g:which_key_floating_opts = { 'row': '-10', 'width': '-10' }
    nnoremap <silent> <leader>      :<c-u>WhichKey '<leader>'<CR>
    nnoremap <silent> <localleader>      :<c-u>WhichKey '<localleader>'<CR>
    augroup vim_which_key
        autocmd  FileType which_key  :setl foldlevel=20 foldcolumn=0
    augroup end

    " vim-highlightedyank
    if !exists('##TextYankPost')
        map y <Plug>(highlightedyank)
    endif
    
    " asynctasks
    let g:asynctasks_term_reuse = 1
    let g:asynctasks_term_pos = 'tab'

    noremap <silent><F5> :AsyncTask file-run<cr>
    noremap <silent><F6> :AsyncTask file-build<cr>
    noremap <silent><f7> :AsyncTask project-run<cr>
    noremap <silent><f8> :AsyncTask project-build<cr>

    " asyncrun
    function! CmakeBuild()
        let l:dst = asyncrun#get_root('%')
        if filereadable(l:dst . '/CMakeLists.txt')
            let l:num_cpu = system('grep -c ^processor /proc/cpuinfo')
            let l:num_cpu_used = max([l:num_cpu - 2, 1])
            call mkdir(l:dst . '/build', 'p', '0775')
            execute 'AsyncRun -cwd=<root>/build cmake ..; make -j' . l:num_cpu_used
        else
            echo 'CMakeLists.txt not found!'
        endif
    endfunction

    let g:asyncrun_rootmarks = g:root_markers + ['_darcs', 'build.xml'] 
    let g:asyncrun_open = 10
    let g:asyncrun_status = ''
    " nnoremap <silent> <F5> :call CmakeBuild()<cr>
    " nnoremap <silent> <F6> :AsyncRun -cwd=<root>/build -raw make runtest <cr>
    " nnoremap <silent> <F7> :AsyncRun -cwd=<root>/build -raw make run <cr>
    nnoremap <F10> :call asyncrun#quickfix_toggle(10)<cr>
    command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

    " vim-cpp-enhanced-highlight
    let g:cpp_class_scope_highlight = 1
    let g:cpp_member_variable_highlight = 1
    let g:cpp_class_decl_highlight = 1
    let g:cpp_experimental_simple_template_highlight = 1
    let g:cpp_concepts_highlight = 1
    let g:cpp_no_function_highlight = 1

    " python-syntax
    let g:python_highlight_all = 1

    " markdown
    " let g:vim_markdown_folding_disabled=1
    let g:vim_markdown_folding_style_pythonic = 1
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_math = 1
endif
" }}} bundle group: basic

" {{{ bundle group: high
if index(g:bundle_groups, 'high') >= 0
    Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-textobj-indent'
    Plug 'kana/vim-textobj-syntax'
    " Plug 'kana/vim-textobj-entire'
    Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
    Plug 'bps/vim-textobj-python', { 'for': 'python' }
    Plug 'sgur/vim-textobj-parameter'
    Plug 'jceb/vim-textobj-uri'

    Plug 'honza/vim-snippets'
    Plug 'kshenoy/vim-signature'
    Plug 'wakatime/vim-wakatime'
    Plug 'dyng/ctrlsf.vim'
    Plug 'liuchengxu/vista.vim'

    Plug 'Chiel92/vim-autoformat'
    Plug 'simnalamburt/vim-mundo'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'skywind3000/gutentags_plus'
    Plug 'SirVer/ultisnips'
    Plug 'lervag/vimtex', { 'for': ['tex'] }

    " vim-autoformat
    let g:formatdef_clangformat = '"clang-format -style=google"'
    let g:formatter_yapf_style = 'google'
    let g:formatters_python = ['yapf']
    let g:autoformat_autoindent = 0
    let g:autoformat_retab = 0
    let g:autoformat_remove_trailing_spaces = 0

    " mundo, undo helper
    nnoremap <Leader>un :MundoToggle<cr>

    " echodoc
    set noshowmode
    let g:echodoc#enable_at_startup = 1

    " tags
    set tags=./.tags;,.tags
    let g:gutentags_ctags_tagfile = '.tags'
    let g:gutentags_project_root = g:root_markers
    let s:vim_tags = g:runtime_root . 'cache/tags'
    let g:gutentags_cache_dir = s:vim_tags
    let g:gutentags_ctags_exclude = [
                \  '*.git', '*.svn', '*.hg',
                \  'cache', 'build', 'dist', 'bin', 'node_modules', 'bower_components',
                \  '*-lock.json',  '*.lock',
                \  '*.min.*',
                \  '*.bak',
                \  '*.zip',
                \  '*.pyc',
                \  '*.class',
                \  '*.sln',
                \  '*.csproj', '*.csproj.user',
                \  '*.tmp',
                \  '*.cache',
                \  '*.vscode',
                \  '*.pdb',
                \  '*.exe', '*.dll', '*.bin',
                \  '*.mp3', '*.ogg', '*.flac',
                \  '*.swp', '*.swo',
                \  '.DS_Store', '*.plist',
                \  '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png', '*.svg',
                \  '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
                \  '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx', '*.xls',
                \]

    let g:gutentags_modules = []
    if executable('ctags')
        let g:gutentags_modules += ['ctags']
    endif
    if executable('gtags-cscope') && executable('gtags')
        let g:gutentags_modules += ['gtags_cscope']
    endif

    let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
    let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']  " for universal ctags
    let g:gutentags_auto_add_gtags_cscope = 0
    let g:gutentags_plus_height = 10
    let g:gutentags_plus_nomap = 1

    " s: Find this C symbol
    " g: Find this definition
    " d: Find functions called by this function
    " c: Find functions calling this function
    " t: Find this text string
    " e: Find this egrep pattern
    " f: Find this file
    " i: Find files #including this file
    noremap <silent> <leader>tr :GscopeFind s <C-R><C-W><cr>
    noremap <silent> <leader>tg :GscopeFind g <C-R><C-W><cr>
    noremap <silent> <leader>tc :GscopeFind c <C-R><C-W><cr>
    noremap <silent> <leader>ti :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>

    " Snippets are separated from the engine. Add this if you want them:
    let g:UltiSnipsExpandTrigger       = '<tab>'
    let g:UltiSnipsJumpForwardTrigger  = '<c-k>'
    let g:UltiSnipsJumpBackwardTrigger = '<c-j>'
    let g:UltiSnipsSnippetDirectories  = ['UltiSnips', 'mysnippets']
    let g:UltiSnipsSnippetsDir = g:runtime_root . 'plugged/vim-snippets/UltiSnips'
    let g:ultisnips_python_style = 'google'
    let g:UltiSnipsEditSplit = 'vertical'
    map <leader>us :UltiSnipsEdit<CR>

    " vista.vim
    function! NearestMethodOrFunction() abort
        return get(b:, 'vista_nearest_method_or_function', '')
    endfunction

    set statusline+=%{NearestMethodOrFunction()}
    let g:vista_sidebar_position = 'vertical topleft'
    nnoremap <leader>v :Vista!!<cr>

    " By default vista.vim never run if you don't call it explicitly.
    "
    " If you want to show the nearest function in your statusline automatically,
    " you can add the following line to your vimrc
    autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

    " vimtex
    if has('nvim')
        let g:vimtex_compiler_progname = 'nvr'
    endif
    let g:vimtex_fold_enabled = 0
    let g:vimtex_view_method = 'general'
    let g:vimtex_view_general_viewer = 'okular'
    if get(g:, 'vimtex_view_general_viewer', '') ==# 'okular'
        let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
        let g:vimtex_view_general_options_latexmk = '--unique'
    endif
    let g:vimtex_compiler_latexmk = { 'continuous' : 1 }
    let g:vimtex_compiler_latexmk = {
        \ 'options' : [
        \   '-xelatex',
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}

endif
" }}} bundle group: high

" {{{ bundle group: optional
if index(g:bundle_groups, 'optional') >= 0
    Plug 'tpope/vim-projectionist'
    Plug 'tpope/vim-speeddating'
    Plug 'tpope/vim-scriptease'
    Plug 'vim-jp/vital.vim'
    Plug 'wsdjeg/FlyGrep.vim'
    Plug 'asins/vim-dict'
    Plug 'terryma/vim-expand-region'
    Plug 'scrooloose/nerdcommenter'
    Plug 'justinmk/vim-dirvish'
    Plug 'scrooloose/nerdtree'
    Plug 'mattn/emmet-vim', { 'for': ['html', 'css'] }
    Plug 'liuchengxu/space-vim-dark'
    Plug 'sillybun/vim-repl'
    Plug 'vim-scripts/DoxygenToolkit.vim', { 'for': ['c', 'cpp'] }
    Plug 'lilydjwg/fcitx.vim', { 'for': ['markdown', 'tex'] }
    Plug 'Shougo/echodoc.vim'

    " nerdtree
    let g:NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$', '^\.svn$', '^\.hg$' ]

    " nerdcommenter
    let g:NERDSpaceDelims = 1
    let g:NERD_cpp_alt_style=1

    " doxygen
    let g:DoxygenToolkit_authorName='meijieru, meijieru@gmail.com'

endif
" }}} bundle group: optional

" {{{ bundle group: tagbar
if index(g:bundle_groups, 'tagbar') >= 0
    Plug 'majutsushi/tagbar'

    nnoremap <Leader>tb :Tagbar<CR>
    let g:tagbar_autofocus=1
    let g:tagbar_width=25
    let g:tagbar_left=1
    let g:tagbar_map_showproto='K'
endif
" }}} bundle group: tagbar

" {{{ bundle group: ale
if index(g:bundle_groups, 'ale') >= 0
    Plug 'w0rp/ale'

    " syntax checker
    let g:ale_sign_error = '•'
    let g:ale_sign_warning = '•'
    highlight link ALEErrorSign    Error
    highlight link ALEWarningSign  Warning
    let g:ale_linters = {
    \   'cpp': ['clang'],
    \   'c': ['clang'],
    \   'python': ['flake8']
    \}
    let g:ale_echo_msg_format = '[%linter%] %code: %%s'
    let g:ale_lint_on_text_changed = 'normal'
    let g:ale_lint_on_insert_leave = 1
    " TODO(meijieru): replace echo and use format
    let g:ale_virtualtext_cursor = 1

    " https://github.com/dense-analysis/ale/issues/1914#issuecomment-421316065
    let g:ale_virtualenv_dir_names = []

    let g:ale_cpp_clang_options = '-std=c++11 -Wall'
endif
" }}} bundle group: ale

" {{{ bundle group: ycm
if index(g:bundle_groups, 'ycm') >= 0
    Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --system-libclang --system-boost' }
    LoadScript site/bundle/ycm.vim
endif
" }}} bundle group: ycm

" {{{ bundle group: lsp
if index(g:bundle_groups, 'lsp') >= 0
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': './install.sh' }

    " set hidden " Required for operations modifying multiple buffers like rename.
    let g:LanguageClient_diagnosticsList = 'Location'
    let g:LanguageClient_diagnosticsEnable = 0
    let g:Lf_UseVersionControlTool = 0
    let g:LanguageClient_rootMarkers = g:root_markers
    let g:LanguageClient_serverCommands = {
        \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
        \ 'python': ['pyls']
        \ }
    " set omnifunc=LanguageClient#complete

    nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
    nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
    nnoremap <silent> <leader>gdf :call LanguageClient_textDocument_definition()<CR>
    nnoremap <silent> <leader>gr :call LanguageClient_textDocument_references()<CR>
endif
" }}} bundle group: lsp
"
" {{{ bundle group: coc
if index(g:bundle_groups, 'coc') >= 0
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    LoadScript site/bundle/coc.vim
endif
" }}} bundle group: coc

" {{{ bundle group: deoplete
if index(g:bundle_groups, 'deoplete') >= 0
    if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif

    " deoplete
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#complete_method = 'omnifunc'
    inoremap <silent><expr> <c-space>  deoplete#mappings#manual_complete()
endif
" }}} bundle group: deoplete

" {{{ bundle group: vcs
if index(g:bundle_groups, 'vcs') >= 0
    Plug 'tpope/vim-fugitive'
    Plug 'mhinz/vim-signify'

    nnoremap <leader>gl :Git lg<CR>
    nnoremap <leader>gs :Gstatus<CR>
    nnoremap <leader>gv :Gvdiff<CR>
endif
" }}} bundle group: vcs

" {{{ bundle group: airline
if index(g:bundle_groups, 'airline') >= 0
    Plug 'vim-airline/vim-airline'

    let g:airline_powerline_fonts = 1
    let g:airline#extensions#whitespace#enabled = 0
endif
" }}} bundle group: airline

" {{{ bundle group: vimspector
if index(g:bundle_groups, 'vimspector') >= 0
    Plug 'puremourning/vimspector', { 'do': './install_gadget.py --enable-c --enable-python --enable-bash' }

    function! ToggleDebugMapping()
        if len(g:pre_vimspector_mapping) > 0
            call auxlib#restore_mappings(g:pre_vimspector_mapping)
            let g:pre_vimspector_mapping = {}
        else
            let l:vimspector_keyset_mappings = {
                        \ 'HUMAN': {
                        \    '<F5>':         '<Plug>VimspectorContinue',
                        \    '<F3>':         '<Plug>VimspectorStop',
                        \    '<F4>':         '<Plug>VimspectorRestart',
                        \    '<F6>':         '<Plug>VimspectorPause',
                        \    '<F9>':         '<Plug>VimspectorToggleBreakpoint',
                        \    '<leader><F9>': '<Plug>VimspectorToggleConditionalBreakpoint',
                        \    '<F8>':         '<Plug>VimspectorAddFunctionBreakpoint',
                        \    '<F10>':        '<Plug>VimspectorStepOver',
                        \    '<F11>':        '<Plug>VimspectorStepInto',
                        \    '<F12>':        '<Plug>VimspectorStepOut',
                        \ },
                        \ }
            let l:vimspector_keyset = l:vimspector_keyset_mappings['HUMAN']

            let g:pre_vimspector_mapping = auxlib#save_mappings(keys(l:vimspector_keyset), 'n', 1)
            for [key, value] in items(l:vimspector_keyset)
                let l:command =  'nmap ' . key . ' ' . value
                execute l:command
            endfor
        endif
    endfunction

    let g:pre_vimspector_mapping = {}
    nnoremap <leader><F5> :call ToggleDebugMapping()<cr>
endif
" }}} bundle group: vimspector

call plug#end()

" {{{ Post process
if index(g:bundle_groups, 'airline') >= 0
    if exists("g:asyncrun_status")
        let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
    endif
endif

" {{{ bundle group: auxlib
if index(g:bundle_groups, 'auxlib') >= 0
    let g:auxlib#enable_at_startup = 1
    let g:auxlib#_logging = {'level': 'info', 'logfile': g:runtime_root . 'log/auxlib.log', 'overwrite': 1}

    augroup auxlib
        autocmd!
        autocmd QuickFixCmdPost *grep* cwindow
    augroup end

    nnoremap <leader>gg :call auxlib#mygrep()<cr>
    nnoremap <Leader>te :call auxlib#toggle_loclist()<cr>
endif
" }}} bundle group: auxlib

" }}} Post process
