function! Ruby_eval_vsplit() range
  let src = tempname()
  let dst = tempname()
  execute ": " . a:firstline . "," . a:lastline . "w " . src
  execute ":silent ! ruby " . src . " > " . dst . " 2>&1 "
  execute ":pclose!"
  execute ":redraw!"
  execute ":vsplit ".dst
  execute ":set pvw"
  execute ":wincmd w"
endfunction
