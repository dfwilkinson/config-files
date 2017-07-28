" generic helper functions

function SetScrollbind()
   set scrollbind
   set scrollopt=ver,jump,hor
   set nowrap
   syncbind
endfunction

function! UnsetScrollbind()
   set noscrollbind
endfunction  

function! SetDiff()
   call SetScrollbind()
   set foldmethod=diff
   set diff
endfunction

function! UnsetDiff()
   set nodiff
   call UnsetScrollbind() 
endfunction  

function! SetupPreviewWindow()
   call UnsetDiff()        " in case it was set before and not appropriate now
   setlocal nobuflisted    " don't show contents in e.g. qbuf
   setlocal bufhidden=wipe " wipe buffer when window closed
   setlocal nomodifiable   " shouldn't change the contents
   setlocal previewwindow  " this is a preview window
endfunction

function! ClosePreviewWindow()
   call UnsetDiff()        " remove buffer in current window from diff list
   pclose                  " close preview window
endfunction

" main helper functions

function! CaptureShellOutputInTempfile( bufString, commandString )
   let srcFile=expand( a:bufString )
   let outputFile=tempname()
   silent! execute "!".a:commandString." ".srcFile." > ".outputFile
   return outputFile
endfunction

function! PreviewFile( filename, verticalQ )
   pclose!
   let splitCommand = "split "
   if a:verticalQ
      let splitCommand = "v".splitCommand
   endif
   silent! execute splitCommand.a:filename
   call SetupPreviewWindow()
endfunction

function! PreviewShellOutput( bufString, commandString, verticalQ )
   let tempFile = CaptureShellOutputInTempfile( a:bufString, a:commandString )
   call PreviewFile( tempFile, a:verticalQ )
endfunction
   
function ResizeWindowToFitPosition( movementString, verticalQ )
" sample movement strings: whole file="G", 1st paragraph="gg}", 2nd "--"="gg/--n"
   let old_statusmsg = v:statusmsg
   silent! execute "normal ".a:movementString."g\<c-g>"
   if a:verticalQ
      let newWidth = str2nr(split(v:statusmsg)[1]) + str2nr(&numberwidth)
      silent! execute "vertical resize" newWidth
   else
      let newHeight = str2nr(split(v:statusmsg)[5])
      silent! execute "resize" newHeight
   endif 
   let v:statusmsg = old_statusmsg
   silent! execute "normal gg0"
endfunction

function! StartG4diff()
   call PreviewShellOutput( "%", "g4 cat", 1 )   
   call SetDiff()
   wincmd w
   call SetDiff()
endfunction


" functions for interacting with subversions

function! StartSVNdiff()
   call PreviewShellOutput( "%", "svn cat", 1 )   
   call SetDiff()
   wincmd w
   call SetDiff()
endfunction

function! StartSVNdiffWithPrev()
   call inputsave()
   let revisionNumber = input("revision number: ")
   call inputrestore()
   if ( revisionNumber == "" )
      let revisionNumber="PREV"
   endif
   echo "using revision number: ".revisionNumber
   call PreviewShellOutput( "%", "svn cat -r ".revisionNumber, 1 )   
   call SetDiff()
   wincmd w
   call SetDiff()
endfunction

function! ShowSVNblame()
   call PreviewShellOutput( "%", "svn blame", 1 )   
   call SetScrollbind()
   call ResizeWindowToFitPosition( "wwhh", 1 )
   wincmd w
   call SetScrollbind()
endfunction

function! ShowSVNlog()
   call PreviewShellOutput( "%", "svn log -v", 0 )   
   call ResizeWindowToFitPosition( "ggj/--n", 0 )
   wincmd w
endfunction

function! ShowSVNstatus()
   call PreviewShellOutput( "%:h", "svn status -u", 0 )   
   call ResizeWindowToFitPosition( "G", 0 )
   wincmd w
endfunction
