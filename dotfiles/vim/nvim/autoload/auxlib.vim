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
