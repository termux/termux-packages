termux_step_check_prefix() {
	new_files=$(find $TERMUX_PREFIX -newer "$TERMUX_BUILD_TS_FILE" -type f)

	if [ ! -z "$new_files" ]; then
		termux_error_exit "$TERMUX_PREFIX was modified:

$new_files

Please change the build script so that files are installed straight into TERMUX_PKG_MASSAGEDIR instead of PREFIX."
	fi
}
