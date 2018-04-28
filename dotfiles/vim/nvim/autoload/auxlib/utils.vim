function auxlib#utils#neovim_version() abort
  redir => l:v
  silent version
  redir END
  return split(l:v, '\n')[0]
endfunction
