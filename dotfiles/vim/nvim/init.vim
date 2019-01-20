" change leader
let g:mapleader = ' '
let g:maplocalleader = ' '

" global var
let g:root_markers = ['.svn', '.git', '.root', '.project'] 
let g:vim_config_root = fnamemodify(expand('<sfile>'), ':h')
let g:runtime_root = expand('~/.local/share/nvim/site/')
let g:bundle_groups = ['simple', 'basic', 'high', 'ale', 'ycm', 'vcs', 'airline', 'auxlib']

" speed up startup
let g:python_host_prog = $ANACONDA_HOME . '/bin/python2'
let g:python3_host_prog = $ANACONDA_HOME . '/bin/python3'

" install plugins
let s:plugin_config_file = g:vim_config_root . '/bundle.vim'
execute 'source' . s:plugin_config_file

" {{{ General Settings
set history=2000

syntax on
filetype on
filetype indent on
filetype plugin on

set autoread                " auto reload the file when the file is modified
set shortmess=atI           " start-up information

set backup
set backupext=.bak
set undofile                " So is persistent undo ...
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo
set wildmenu
set wildignore+=*.swp,*.bak,*.pyc,*.class,*.svn,*.tf,*.mdb,*.t7,*.o,*.so,*.npy
set clipboard^=unnamedplus   " use + register for usual operation
set completeopt=longest,menu " refer to VimTip1228

let &backupdir = g:runtime_root . 'files/backup'
let &directory = g:runtime_root . 'files/swap/'
let &viminfo = '100,n' . g:runtime_root . 'files/info/viminfo'
let &undodir = g:runtime_root . '/files/undo'


" No annoying sound on errors
set title                " change the terminal's title
set novisualbell         " don't beep
set noerrorbells         " don't beep
set timeoutlen=500

" For regular expressions turn magic on
set magic

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" }}} General Settings

" {{{ Display Settings
set ruler
set showcmd
set number
set nowrap
set scrolloff=5 " when scroll the screen, the lines remain to show

" command line's height
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
set laststatus=2 " Always show the status line - use 2 lines for the status bar

" match
set showmatch
set matchtime=2 " How many tenths of a second to blink when matching brackets

" search
set hlsearch
set incsearch
set ignorecase
set smartcase     " ignore case if search pattern is all lowercase, case-sensitive otherwise

" folding
set foldenable
set foldmethod=indent

" tab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
set expandtab     " convert Tab into space    [for true Tab, Ctrl+V + Tab]
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'

" use decimal
set nrformats=

" theme
set termguicolors
set background=light
colorscheme gruvbox

" visual enhance
" set cursorcolumn
set cursorline
" set mousehide               " Hide the mouse cursor while typing

" Control column highlight
if &background ==? 'dark'
    highlight ColorColumn ctermbg=234 guibg=#1d2021
else
    highlight ColorColumn ctermbg=230 guibg=#f9f5d7
endif
nnoremap <F1> :call auxlib#toggle_colorcolumn()<CR>
inoremap <F1> <C-o>:call auxlib#toggle_colorcolumn()<CR>

" for error highlight
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

" set some keyword to highlight
augroup highlight_keywords
    autocmd!
    autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|CHANGED\|DONE\|XXX\|HACK\)')
    autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\|FIXME\|BUG\)')
augroup end

" }}} Display Settings

" {{{ FileEncode Settings

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set helplang=cn
set termencoding=utf-8

" Use Unix as the standard file type
set fileformats=unix,dos,mac

set formatoptions+=m
set formatoptions+=B " do not add space when merge two chinese line

" }}} FileEncode Settings

" {{{ Others 

" set up preview
" https://stackoverflow.com/questions/3712725/can-i-change-vim-completion-preview-window-height
set previewheight=10
function! PreviewHeightWorkAround()
    if &previewwindow
        exec 'setlocal winheight='.&previewheight
    endif
endfunction
augroup set_preview
    autocmd!
    autocmd InsertLeave * if pumvisible() == 0|pclose|endif
    autocmd BufEnter ?* call PreviewHeightWorkAround()
augroup end

" auto jump to last modified position
augroup aux
    autocmd!
    autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
augroup end

" }}} Others 

" {{{ HotKey Settings 

inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

"Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

"Reselect visual block after indent/outdent.
vnoremap < <gv
vnoremap > >gv

" auto jump to end of select
" vnoremap <silent> y y`]
" vnoremap <silent> p p`]
" nnoremap <silent> p p`]

" faster command mode
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>
" cnoremap <c-f> <c-d>
" cnoremap <c-b> <left>
" cnoremap <c-_> <c-k>

" }}} HotKey Settings 

" {{{ FileType Settings

augroup filetype_specify
    autocmd!
    autocmd filetype python setlocal tabstop=4 shiftwidth=4 expandtab ai
    autocmd filetype cuda setlocal ft=cuda.cpp
    autocmd filetype plaintex,latex setlocal ft=tex
    autocmd filetype tex,text,markdown setlocal wrap
    autocmd filetype cpp,c setlocal nowrap commentstring=//\ %s
augroup end

" }}} FileType Settings

" {{{ Environment-dependent Settings

" nvim related
if has('nvim')
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    autocmd VimLeave * set guicursor=a:block-blinkon0
end

" }}} Environment-dependent Settings
