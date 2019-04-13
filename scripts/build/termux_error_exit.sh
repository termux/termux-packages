termux_error_exit() {
	echo "ERROR: $*" 1>&2
	exit 1
}
