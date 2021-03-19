" {{{ General Settings
set history=2000

syntax on
filetype on
filetype indent on
filetype plugin on

set autoread                " auto reload the file when the file is modified
set shortmess=actIT          " start-up information
set cmdheight=1

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
let &undodir = g:runtime_root . 'files/undo'


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
