" Open quickfix window for build errors
function! CViewErrors(includeWarnings)
  " Add your error patterns here
  let l:epatterns = { 'glint':'%f:%l:%c: %m', 'blaze':'%tRROR: %f:%l:%c: %m', 'javac':'%f:%l: %m' }

  " Add your warning patterns here
  let l:wpatterns = { 'blaze':'%tARNING: %f:%l:%c: %m' }

  let l:pattern = ''
  for p in values(l:epatterns)
    if l:pattern == ''
      let l:pattern = p
    else
      let l:pattern = l:pattern . ',' . p
    endif
  endfor
  if a:includeWarnings
    for p in values(l:wpatterns)
      if l:pattern == ''
        let l:pattern = p
      else
        let l:pattern = l:pattern . ',' . p
      endif
    endfor
  endif
  let &efm = l:pattern
  if $C_VIM_TEMP_FILE == ''
    echoerr 'Environment $C_VIM_TEMP_FILE is not set!'
  else
    cfile $C_VIM_TEMP_FILE
    copen
  endif
endfunction
