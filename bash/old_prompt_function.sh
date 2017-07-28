PShost=${HOSTNAME%%.*}
TERMINFO="$(tty)"

function prompt_function {
	prompt_error_status=${?}
	prompt_n_jobs=$(jobs | wc -l)
	prompt_filler_length=${COLUMNS}
	PSerrs=""
	PSjobs=""
	PSsep=""
	if [ "${prompt_error_status}" -ne "0" ]; then
		PSerrs=$(printf "%03d" ${prompt_error_status})
		PSerrs=" error=${PSerrs} "
	fi
	if [ "${prompt_n_jobs}" -ne "0" ]; then
		prompt_n_jobs_str=$(printf "%02d" ${prompt_n_jobs})
		prompt_jobs=$(jobs | awk '{split(substr($0,31,30),temp," &"); printf(",%s",temp[1])}' | cut -c2-72)
		PSjobs="jobs=${prompt_n_jobs_str}(${prompt_jobs})
"
	fi
	while [ "$prompt_filler_length" -gt "0" ]; do
		PSsep="_${PSsep}"
		let prompt_filler_length=${prompt_filler_length}-1
	done

	# Set title of xterm 
	case $TERM in
		xterm|rxvt|aterm|xterm-color)
# 			xterm_title="${PShost}(${TERMINFO}):${DIRSTACK}"
			xterm_title="${PShost}:${DIRSTACK}"
			echo -ne "\033]0;${xterm_title}\007"
			;;
		screen)
# 			term_info=${STY}
			term_info=$(echo ${STY} | awk '{split($0,a,".");print a[2];}')
# 			xterm_title="SCR(${term_info}) on ${PShost}:${DIRSTACK}"
# 			xterm_title="${PShost}:${DIRSTACK} [${term_info}]"
# 			xterm_title="X:${term_info} [${PShost}:${DIRSTACK}]"
			xterm_title="${term_info} [${PShost}:${DIRSTACK}]"
			echo -ne "\033]0;${xterm_title}\007"
# 			PSsep="argh"
			;;
	esac
}
