function auxlib#utils#neovim_version() abort
    redir => l:v
    silent version
    redir END
    return split(l:v, '\n')[0]
endfunction

function! auxlib#utils#set_global(variable_name, default) abort
    let l:full_name = 'auxlib#' . a:variable_name
    let l:value = get(g:, l:full_name, a:default)
    let g:[l:full_name] = l:value
    return l:value
endfunction
