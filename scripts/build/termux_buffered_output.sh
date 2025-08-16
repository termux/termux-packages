termux_buffered_output() {
	( # Do everything in a subshell to avoid any kind of mess.
		TAG="$1"
		set +e
		# curl progress meter uses carriage return instead of newlines, fixing it
		sed -u 's/\r/\n/g' | while :; do
			local buffer=()
			# One second buffer to prevent mixing lines and make output consistent.
			sleep 1;
			while :; do
				# read with 0 timeout does not read any data so giving minimal timeout
				IFS='' read -t 0.001 -r line; rc=$?
				# append job name to the start for tracking multiple jobs
				[[ $rc == 0 ]] && buffer+=( "[$TAG]: $line" )
				# Probably EOF or timeout
				[[ $rc == 1 || $rc -ge 128 ]] && break
			done

			# prevent output garbling by using scripts directory for locking
			[[ "${#buffer[@]}" -ge 1 ]] && flock --no-fork . printf "%s\n" "${buffer[@]}"
			[[ $rc == 1 ]] && break # exit on EOF
		done
	)
}
