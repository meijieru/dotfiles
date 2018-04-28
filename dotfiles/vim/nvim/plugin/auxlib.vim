function TestVim()
    echo 'hello from auxlib vim'
endfunction


if exists('g:loaded_auxlib')
    finish
endif
let g:loaded_auxlib = 1

if get(g:, 'auxlib#enable_at_startup', 0)
    call auxlib#init#enable()
endif
