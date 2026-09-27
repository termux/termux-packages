# We need to trace errors in functions and subshells
set -ET

# And we need to trace if errors were masked or not to print correct stacktrace
shopt -s extdebug

# Create IPC pipe
IPC_FIFO="${TMPDIR:-/tmp}/TERMUX_LOGGER.$$.$(($RANDOM % 100000))"
mkfifo "$IPC_FIFO"

NOTREADY=1
trap 'NOTREADY=0' SIGUSR1
TRACK_PID=$$

# Subshell reads from the pipe and exits when parent closes it
(
	declare -A EXIT_CODES
	declare -A STACKTRACES
	LAST=0
	# Open IPC pipe node and signal parent shell it is safe to remove the node
	exec {readfd}<"$IPC_FIFO"  # read end
	kill -USR1 $TRACK_PID

	# Linux filenames disallows only '/' and '\0' (slash and null byte) in filenames
	# but we can not use them as separators because slash appears is being used as
	# separator in paths and bash treats null byte as the end of string.
	# Using Unit Separator in filenames is allowed but it is extremely rare so we will use it.
	US=$'\x1F'

	# Format of lines is "S$US$SUBSHELL_NUMBER$US$STATUS_CODE$US$FUNCNAME:$SOURCE:$LINENO[$US$FUNCNAME2:$SOURCE2:$LINENO2][...]"
	# If parameter does not exist in line the variable will be unset
	while IFS="$US" read -r _ACTION _LAST _EXIT_CODE _STACKTRACE <&${readfd}; do
		case "$_ACTION" in
		S) # STACK TRACE
			EXIT_CODES[$_LAST]="$_EXIT_CODE"
			STACKTRACES[$_LAST]="$_STACKTRACE"
			LAST="$_LAST"
		;;
		L) # LAST SUBSHELL NUMBER
			if (( _LAST < LAST )); then
				for i in ${!STACKTRACES[@]}; do
					# bash ignored exit code so we do not need stacktraces of subshells if any
					(( i > _LAST )) && unset EXIT_CODES[$i] STACKTRACES[$i]
				done
				LAST="$_LAST"
			fi
		;;
		*)
			echo "LOGGER: unknown command $_ACTION";;
		esac
	done
	if (( ${EXIT_CODES[0]:-0} != 0 )); then
		DEEPEST=0
		for n in "${!STACKTRACES[@]}"; do
			(( n > DEEPEST )) && DEEPEST=$n
		done

		>&2 echo "[ ERROR ]: $(basename $0) exited with error ${EXIT_CODES[$DEEPEST]}:"
		# We print only the error from the deepest subshell since it is the root problem
		for ((k=$DEEPEST; k>=0; k--)); do
			IFS="$US" read -ra items <<< "${STACKTRACES[$k]}"
			for ((i=0; i<${#items[@]}; i+=3)); do
				>&2 echo "[ TRACE ]: ${items[i]:-}() in ${items[i+1]:-}:${items[i+2]:-}"
			done
		done
	fi
) &

LOGGER_PID=$!

# Now we define the error handler
termux_save_stacktrace() {
	trap - DEBUG
	US=$'\x1F'
	local func src lineno skip=0

	if [[ " ${FUNCNAME[*]} " == *" exit "* ]]; then
		# we should not log successful exits and exit func should not appear in stacktrace
		(( $1 == 0 )) || (( skip++ )) && builtin exit 0
	fi

	# error handler should not appear in stacktrace as well
	[[ " ${FUNCNAME[*]} " == " termux_save_stacktrace "* ]] && ((skip++)) || true

	_STACKTRACE="S$US$BASH_SUBSHELL$US$1"
	for i in ${!FUNCNAME[@]}; do
		(( i < skip )) && continue
		func="${FUNCNAME[$i]}"
		src="${BASH_SOURCE[$i]}"
		lineno="${BASH_LINENO[$((i - 1))]}"
		_STACKTRACE+="$US$func$US$src$US$lineno"
	done

	# Send it to the logger daemon/subshell we started earlier
	echo "$_STACKTRACE" >&${LOGGER_FD}
	builtin exit $1
}

# `exit 1` does not trigger ERR trap, but we need to log it as well
exit() {
	trap - DEBUG
	termux_save_stacktrace $1
	builtin exit "$@"
}

# Open logger ipc pipe
exec {LOGGER_FD}>"$IPC_FIFO"  # write end
while (( NOTREADY )); do sleep 0.01; done

# Close ipc fifo write end to trigger logger shutdown. Not inherited by subshells.
# We should wait for logger exit to make sure it will print stacktrace before parent shell is being finished to make sure stacktrace will appear in CI log.
trap "trap - DEBUG; exec {LOGGER_FD}>&-; wait $LOGGER_PID" EXIT

# We do not want our ipc pipe to leak so we will clean it up here.
rm -f "$IPC_FIFO"

# LOGGER_FD is intentionally leaked here
unset NOTREADY TRACK_PID IPC_FIFO LOGGER_PID

# Register our error handler
trap 'status=$?; trap - DEBUG; termux_save_stacktrace $status' ERR

# We can't reliably detect whether an error was ignored or masked by the script (like in SC2155),
# but we do know that when `set -e` triggers a fatal exit, the DEBUG trap is not invoked.
# Also we should ignore compound commands since DEBUG trap is being triggered AFTER their invocation.
trap 'saved=$?; [[ "${FUNCNAME[0]:-}" =~ ^termux_save_stacktrace$ || "$BASH_COMMAND" == "( "* ]] || echo L'$'\x1F''$BASH_SUBSHELL >&${LOGGER_FD}' DEBUG
