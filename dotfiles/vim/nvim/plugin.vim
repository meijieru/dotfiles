" Install vim-plug if we don't already have it
if empty(glob(g:runtime_root . 'autoload/plug.vim'))
    " Ensure all needed directories exist  (Thanks @kapadiamush)
    for s:dir in [ 'plugged', 'autoload', 'files/backup', 'files/info', 'files/swap', 'files/undo']
        execute '!mkdir -p ' . g:runtime_root . s:dir
    endfor
    " Download the actual plugin manag'er
    execute '!curl -fLo ' . g:runtime_root . 'autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

" {{{ plugin config 

call plug#begin(g:runtime_root . 'plugged')

" basic
if index(g:bundle_groups, 'basic') >= 0
    Plug 'skywind3000/asyncrun.vim'
    Plug 'vim-scripts/DoxygenToolkit.vim'
    Plug 'dccmx/google-style.vim'
    Plug 'jmcantrell/vim-virtualenv', { 'for': ['python'] }
    Plug 'vim-scripts/fcitx.vim', { 'for': ['markdown'] }
    Plug 'w0rp/ale'
    Plug 'scrooloose/nerdcommenter'
    Plug 'easymotion/vim-easymotion'
    Plug 'Chiel92/vim-autoformat'
    Plug 'tpope/vim-fugitive'
    Plug 'mhinz/vim-signify'
    Plug 'jiangmiao/auto-pairs'

    Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-textobj-indent'
    Plug 'kana/vim-textobj-syntax'
    Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
    Plug 'sgur/vim-textobj-parameter'

    Plug 'kshenoy/vim-signature'
    Plug 'tpope/vim-surround'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'godlygeek/tabular'
    Plug 'plasticboy/vim-markdown'

    Plug 'wakatime/vim-wakatime'

    " autocomplete
    Plug 'Shougo/echodoc.vim'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'lervag/vimtex'
    Plug 'mattn/emmet-vim'

    " display enhance
    Plug 'luochen1990/rainbow'
    Plug 'morhetz/gruvbox'
    Plug 'vim-airline/vim-airline'
    Plug 'Yggdroot/indentLine'

    " navigation
    Plug 'scrooloose/nerdtree'
    Plug 'majutsushi/tagbar'
    Plug 'simnalamburt/vim-mundo'
    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

    " fallback
    Plug 'sheerun/vim-polyglot'


    " }}} plugin config 

    " {{{ basic

    " doxygen
    let g:DoxygenToolkit_authorName='meijieru, meijieru@gmail.com'
    let g:DoxygenToolkit_commentType = 'C++'

    " syntax checker
    let g:ale_sign_error = '✗'
    let g:ale_sign_warning = '>'
    let g:ale_linters = {
    \   'cpp': ['clang'],
    \   'c': ['clang'],
    \   'python': ['flake8']
    \}
    let g:ale_echo_msg_format = '[%linter%] %code: %%s'
    let g:ale_lint_on_text_changed = 'normal'
    let g:ale_lint_on_insert_leave = 1
    let g:ale_cpp_clang_options = '-Wall -std=c99 '
    let g:ale_cpp_clang_options = '-Wall -std=c++11 '

    function! ToggleErrors()
    for l:buffer in tabpagebuflist()
        if bufname(l:buffer) ==# ''
        " then it should be the loclist window
        lclose
        return
        endif
    endfor
    lopen
    endfunction
    nnoremap <Leader>te :call ToggleErrors()<cr>

    " nerdcommenter
    let g:NERDSpaceDelims = 1
    let g:NERD_cpp_alt_style=1

    " auto cd to the current file's dir
    " au BufRead,BufNewFile,BufEnter * cd %:p:h

    " tags
    set tags=./.tags;,.tags
    let g:gutentags_ctags_tagfile = '.tags'
    let g:gutentags_project_root = g:root_markers
    let s:vim_tags = g:runtime_root . 'cache/tags'
    let g:gutentags_cache_dir = s:vim_tags

    let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
    let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

    if !isdirectory(s:vim_tags)
    silent! call mkdir(s:vim_tags, 'p')
    endif

    " markdown
    " let g:vim_markdown_folding_disabled=1
    let g:vim_markdown_folding_style_pythonic = 1
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_math = 1

    " easymotion
    let g:EasyMotion_smartcase = 1
    "let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
    map <Leader><leader>h <Plug>(easymotion-linebackward)
    map <Leader><Leader>j <Plug>(easymotion-j)
    map <Leader><Leader>k <Plug>(easymotion-k)
    map <Leader><leader>l <Plug>(easymotion-lineforward)
    map <Leader><leader>. <Plug>(easymotion-repeat)

    " vim-fugitive, git integration
    function! MyGrep() abort
        let l:prompt = 'vimgrep: '
        let l:command_template = ':silent vimgrep /%s/j %%'
        if exists(':Ggrep')
            let l:prompt = 'Ggrep: '
            let l:command_template = ':silent Ggrep! %s'
        endif
        let l:pattern = input(l:prompt, expand('<cword>'))
        if (empty(l:pattern))
            return
        endif
        let l:command = printf(l:command_template, l:pattern)
        execute l:command
    endfunction

    augroup ggrep
        autocmd QuickFixCmdPost *grep* cwindow
    augroup end
    nnoremap <leader>gg :call MyGrep()<cr>

    " vim-autoformat
    let g:formatdef_clangformat = '"clang-format -style=google"'
    let g:formatter_yapf_style = 'google'
    let g:formatters_python = ['yapf']
    " disable fallback
    let g:autoformat_autoindent = 0
    let g:autoformat_retab = 0
    let g:autoformat_remove_trailing_spaces = 0

    " auto-pairs
    let g:AutoPairsMapCh = 0 " Interfere with <left>

    " }}} basic

    " {{{ auto complete

    let g:echodoc#enable_at_startup = 1

    " Snippets are separated from the engine. Add this if you want them:
    let g:UltiSnipsExpandTrigger       = '<tab>'
    let g:UltiSnipsJumpForwardTrigger  = '<c-b>'
    let g:UltiSnipsJumpBackwardTrigger = '<c-f>'
    let g:UltiSnipsSnippetDirectories  = ['UltiSnips']
    let g:UltiSnipsSnippetsDir = g:runtime_root . 'plugged/vim-snippets/UltiSnips'
    let g:ultisnips_python_style = 'google'
    map <leader>us :UltiSnipsEdit<CR>

    " vimtex
    " <localleader>lT  |<plug>(vimtex-toc-toggle)|             `n`
    " <localleader>lY  |<plug>(vimtex-labels-toggle)|          `n`
    " <localleader>lv  |<plug>(vimtex-view)|                   `n`
    " <localleader>ll  |<plug>(vimtex-compile)|                `n`
    " <localleader>lL  |<plug>(vimtex-compile-selected)|       `nx`
    " <localleader>lc  |<plug>(vimtex-clean)|                  `n`
    " <localleader>lC  |<plug>(vimtex-clean-full)|             `n`
    let g:vimtex_fold_enabled = 1
    let g:vimtex_view_general_viewer = 'okular'
    let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
    let g:vimtex_view_general_options_latexmk = '--unique'
    let g:vimtex_latexmk_continuous = 0
    if !exists('g:ycm_semantic_triggers')
        let g:ycm_semantic_triggers = {}
    endif
    " }}} auto complete

    " {{{ display enhance

    " rainbow for pairs
    let g:rainbow_active=1

    " gruvbox
    let g:gruvbox_italic=1
    let g:gruvbox_improved_warnings=1

    " vim-airline
    let g:airline_powerline_fonts = 1

    " indentline
    let g:tex_conceal=''    " compatible with latex
    let g:indentLine_concealcursor=0  " work with cursorline

    " }}} display enhance

    " {{{ navigation

    " nerdtree
    map <leader>tr :NERDTreeToggle<CR>
    let g:NERDTreeHighlightCursorline=1
    let g:NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$', '^\.svn$', '^\.hg$' ]
    "close vim if the only window left open is a NERDTree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | end
    let g:NERDTreeMapOpenSplit = 's'
    let g:NERDTreeMapOpenVSplit = 'v'

    " LeaderF
    let g:Lf_ShortcutF = '<leader>ff'
    let g:Lf_ShortcutB = '<leader>fb'
    nnoremap <leader>fm :LeaderfMru<cr>
    nnoremap <leader>fc :LeaderfFunction<cr>
    nnoremap <leader>ft :LeaderfTag<cr>

    let g:Lf_RootMarkers = g:root_markers
    let g:Lf_WorkingDirectoryMode = 'c'  " FIXME(meijieru): bug from leaderf
    let g:Lf_WindowHeight = 0.35
    let g:Lf_CacheDirectory = g:runtime_root . 'cache'
    let g:Lf_ShowRelativePath = 1
    let g:Lf_StlColorscheme = 'default'
    let g:Lf_StlSeparator = { 'left': '', 'right': '' }

    let g:Lf_NormalMap = {
    \ 'File':   [['<ESC>', ':exec g:Lf_py "fileExplManager.quit()"<CR>'],
    \            ['<F6>', ':exec g:Lf_py "fileExplManager.quit()"<CR>'] ],
    \ 'Buffer': [['<ESC>', ':exec g:Lf_py "bufExplManager.quit()"<CR>'],
    \            ['<F6>', ':exec g:Lf_py "bufExplManager.quit()"<CR>'] ],
    \ 'Mru':    [['<ESC>', ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
    \ 'Tag':    [['<ESC>', ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
    \ 'Function':    [['<ESC>', ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
    \ 'Colorscheme':    [['<ESC>', ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']],
    \ }

    " tagbar
    nnoremap <Leader>tb :Tagbar<CR>
    let g:tagbar_autofocus=1
    let g:tagbar_width=25
    let g:tagbar_left=1
    let g:tagbar_map_showproto='K'

    " mundo, undo helper
    nnoremap <Leader>un :MundoToggle<cr>

    " asyncrun
    function! CmakeBuild()
        let l:dst = asyncrun#get_root('%')
        let l:num_cpu = system('grep -c ^processor /proc/cpuinfo')
        let l:num_cpu_used = max([l:num_cpu - 2, 1])
        call mkdir(l:dst . '/build', 'p', '0775')
        execute 'AsyncRun -cwd=<root>/build cmake ..; make -j' . l:num_cpu_used
    endfunction

    let g:asyncrun_rootmarks = g:root_markers + ['_darcs', 'build.xml'] 
    let g:asyncrun_open = 10
    let g:asyncrun_status = ''
    nnoremap <leader>as :AsyncRun<space>

    " F5：project compile
    " F6：project test
    " F7：project run
    " F10：toggle quickfix
    nnoremap <silent> <F5> :call CmakeBuild()<cr>
    nnoremap <silent> <F6> :AsyncRun -cwd=<root>/build -raw make runtest <cr>
    nnoremap <silent> <F7> :AsyncRun -cwd=<root>/build -raw make run <cr>
    nnoremap <F10> :call asyncrun#quickfix_toggle(10)<cr>

    " work with vim-fugitive
    command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
endif

" }}} navigation

if index(g:bundle_groups, 'ycm') >= 0
    Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --system-libclang --system-boost' }

    let g:ycm_key_invoke_completion = '<C-Space>'
    let g:ycm_key_list_select_completion=['<c-n>']
    let g:ycm_key_list_previous_completion=['<c-p>']
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    let g:ycm_use_ultisnips_completer = 0
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
        \ 'cs,lua,javascript': ['re!\w{2}'], }
    let g:ycm_semantic_triggers.tex = [
        \ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
        \ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
        \ 're!\\hyperref\[[^]]*',
        \ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
        \ 're!\\(include(only)?|input){[^}]*',
        \ 're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
        \ 're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
        \ 're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
        \ 're!\\usepackage(\s*\[[^]]*\])?\s*\{[^}]*',
        \ 're!\\documentclass(\s*\[[^]]*\])?\s*\{[^}]*',
        \ 're!\\[A-Za-z]*',
        \ ]
endif

if index(g:bundle_groups, 'lsp') >= 0
    " TODO
endif

call plug#end()

" Post
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
