if !exists('s:is_enabled')
  let s:is_enabled = 0
endif


function! auxlib#init#init_variable() abort
    if !exists('g:auxlib#_logging')
        let g:auxlib#_logging = {'level': 'info', 'logfile': '', 'overwrite': 0}
    endif
endfunction

function! auxlib#init#enable() abort
    if has('vim_starting')
        augroup auxlib_enable
            autocmd!
            autocmd VimEnter * call auxlib#init#_enable()
        augroup end
        return 1
    endif

    call auxlib#init#_enable()
endfunction

function! auxlib#init#_enable() abort
    if s:is_enabled ==# 1
        return
    endif

    call auxlib#init#init_variable()
    call Auxlib_enable_logging()
    
    let s:is_enabled = 1
endfunction
