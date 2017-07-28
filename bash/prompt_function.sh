function prompt_function {
   local prompt_error_status=${?}
######################################################################
# Create the prompt separator
######################################################################
   PSsep="_______________________________________________________________________________________________________________________________________________________________________________________________________________________"
   PSsep=${PSsep:0:${COLUMNS}}
######################################################################
# Create the hostname and directory readout
######################################################################
   local relativePWD total_length cut_point
   relativePWD=${PWD#${HOME}}
   PSdir=""
   if [ "${#PWD}" -eq "${#relativePWD}" ]; then
      PSdir=${PWD}
   else
      PSdir='~'${relativePWD}
   fi
   let total_length=${#PShost}+${#PSdir}+1
   if [ "${total_length}" -gt "${COLUMNS}" ]; then
      let cut_point=${total_length}-${COLUMNS}+3
      PSdir='...'${PSdir:${cut_point}}
   fi
######################################################################
# Create the list of background jobs 
######################################################################
   local prompt_n_jobs prompt_jobs_intro prompt_jobs total_length cut_point 
   prompt_n_jobs=`jobs | wc -l` # BSD doesn't like $(jobs | wc -l)
   PSjobs=""
   if [ "${prompt_n_jobs}" -ne "0" ]; then
      prompt_jobs_intro="bs"
      prompt_jobs_intro=" jo${prompt_jobs_intro:0:${prompt_n_jobs}} "
      prompt_jobs=$(jobs | awk '{split(substr($0,31,30),temp," &"); printf(",%s",temp[1])}')
      prompt_jobs=${prompt_jobs:1} # remove leading comma
      let total_length=${#prompt_n_jobs}+${#prompt_jobs_intro}+2+${#prompt_jobs}
      if [ "$total_length" -gt "${COLUMNS}" ]; then 
         let cut_point=${COLUMNS}-${#prompt_n_jobs}-${#prompt_jobs_intro}-2-3
         prompt_jobs=${prompt_jobs:0:$cut_point}'...'
      fi 
      PSjobs="${prompt_n_jobs}${prompt_jobs_intro}(${prompt_jobs})
"
   fi
######################################################################
# Create the error display
######################################################################
   PSerrs=""
   if [ "${prompt_error_status}" -ne "0" ]; then
      PSerrs=$(printf "%03d" ${prompt_error_status})
      PSerrs=" error=${PSerrs} 
"
   fi
######################################################################
# Create the time 
######################################################################
   #PSdate=`date +%-l:%M` # BSD doesn't like $(date +%-l:%M)
   #PSdate=`date +%-m-%-d,%-l:%M` # BSD doesn't like $(date +%-l:%M)
   PSdate=`date +%-m-%-d`
   PStime=`date +%-l:%M` # BSD doesn't like $(date +%-l:%M)
   PStimeampm=`date +%P`
   if [ ${SHLVL} -ge 2 ]; then
      PSshlvl="(${SHLVL})"
   fi
######################################################################
# Set title of xterm 
######################################################################
   local xterm_title bracketed_name sshd_test screen_name
   if [ ${#BASH_NAME} -ne "0" ]; then
      bracketed_name="[${BASH_NAME}]"   
   fi
   case $TERM in
      xterm|cygwin|xterm-256color) # |aterm|rxvt|xterm-color)
         xterm_title="${SHELL_TYPE}${bracketed_name}${SSHinfo} ${DIRSTACK}"
         ;;
      screen)
         screen_name=${STY#*.} # strip up to first dot 
         xterm_title="screen[${screen_name%.*}]${SSHinfo} ${DIRSTACK}"
         ;;
   esac
   echo -ne "\033]0;${xterm_title}\007"
}
