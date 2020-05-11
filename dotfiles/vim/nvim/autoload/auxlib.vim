function! auxlib#mygrep() abort
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

function! auxlib#toggle_loclist()
    for l:buffer in tabpagebuflist()
        if bufname(l:buffer) ==# '' " then it should be the loclist window
            lclose
            return
        endif
    endfor
    lopen
endfunction

function! auxlib#toggle_colorcolumn()
    if &colorcolumn ==# ''
        let &colorcolumn=join(range(81,999),',')
        let &colorcolumn='80,'.join(range(120,999),',')
    else
        let &colorcolumn=''
    endif
endfunction

function! auxlib#save_mappings(keys, mode, global) abort
    " https://vi.stackexchange.com/a/7735
    let mappings = {}

    if a:global
        for l:key in a:keys
            let buf_local_map = maparg(l:key, a:mode, 0, 1)

            sil! exe a:mode.'unmap <buffer> '.l:key

            let map_info        = maparg(l:key, a:mode, 0, 1)
            let mappings[l:key] = !empty(map_info)
                        \     ? map_info
                        \     : {
                        \ 'unmapped' : 1,
                        \ 'buffer'   : 0,
                        \ 'lhs'      : l:key,
                        \ 'mode'     : a:mode,
                        \ }

            call auxlib#restore_mappings({l:key : buf_local_map})
        endfor

    else
        for l:key in a:keys
            let map_info        = maparg(l:key, a:mode, 0, 1)
            let mappings[l:key] = !empty(map_info)
                        \     ? map_info
                        \     : {
                        \ 'unmapped' : 1,
                        \ 'buffer'   : 1,
                        \ 'lhs'      : l:key,
                        \ 'mode'     : a:mode,
                        \ }
        endfor
    endif

    return mappings
endfunction

function! auxlib#restore_mappings(mappings) abort
    " https://vi.stackexchange.com/a/7735
    for mapping in values(a:mappings)
        if !has_key(mapping, 'unmapped') && !empty(mapping)
            exe     mapping.mode
                        \ . (mapping.noremap ? 'noremap   ' : 'map ')
                        \ . (mapping.buffer  ? ' <buffer> ' : '')
                        \ . (mapping.expr    ? ' <expr>   ' : '')
                        \ . (mapping.nowait  ? ' <nowait> ' : '')
                        \ . (mapping.silent  ? ' <silent> ' : '')
                        \ .  mapping.lhs
                        \ . ' '
                        \ . substitute(mapping.rhs, '<SID>', '<SNR>'.mapping.sid.'_', 'g')

        elseif has_key(mapping, 'unmapped')
            sil! exe mapping.mode.'unmap '
                        \ .(mapping.buffer ? ' <buffer> ' : '')
                        \ . mapping.lhs
        endif
    endfor
endfunction
