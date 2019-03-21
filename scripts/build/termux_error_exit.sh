termux_error_exit() {
	echo "ERROR: $*" 1>&2
	exit 1
}

if [ "$(uname -o)" = Android ]; then
	termux_error_exit "On-device builds are not supported - see README.md"
fi
