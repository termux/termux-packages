termux_step_create_timestamp_file() {
	# Keep track of when build started so we can see what files
	# have been created.  We start by sleeping/touching so that any
	# generated files ($TERMUX_PREFIX/bin/llvm-config from
	# termux_step_override_config_scripts()) get an older timestamp
	# than the TERMUX_BUILD_TS_FILE.
	sleep 0.1
	TERMUX_BUILD_TS_FILE=$TERMUX_PKG_TMPDIR/timestamp_$TERMUX_PKG_NAME
	touch "$TERMUX_BUILD_TS_FILE"
}
