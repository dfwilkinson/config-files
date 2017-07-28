"let s:colorcolumnLast = &textwidth+1
function! ToggleColorColumn()
  if &colorcolumn == 0
    if !exists("b:colorcolumnLast")
      let b:colorcolumnLast = &textwidth+1
    endif
    if b:colorcolumnLast == 0
      let b:colorcolumnLast = &textwidth+1
    endif
    windo let &colorcolumn=b:colorcolumnLast
    let b:colorcolumnLast = 0
  else
    let b:colorcolumnLast = &colorcolumn
    windo let &colorcolumn = 0
  endif
endfunction
