" {{{ Display Settings
set ruler
set showcmd
set number
set nowrap
set scrolloff=5 " when scroll the screen, the lines remain to show
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

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

