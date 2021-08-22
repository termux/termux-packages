termux_step_create_timestamp_file() {
	# Keep track of when build started so we can see what files
	# have been created.  We start by sleeping so that any
	# generated files (such as zlib.pc) get an older timestamp
	# than the TERMUX_BUILD_TS_FILE.
	sleep 1
	TERMUX_BUILD_TS_FILE=$TERMUX_PKG_TMPDIR/timestamp_$TERMUX_PKG_NAME
	touch "$TERMUX_BUILD_TS_FILE"
}
