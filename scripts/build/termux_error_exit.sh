termux_error_exit() {
	echo -e "ERROR: $*" 1>&2
	exit 1
}
