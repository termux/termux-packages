# shellcheck shell=bash
termux_error_exit() {
	if [ "$#" -eq 0 ]; then
		# Read from stdin.
		printf '%s\n' "$(cat)" >&2
	else
		printf '%s\n' "$*" >&2
	fi
	exit 1
}
