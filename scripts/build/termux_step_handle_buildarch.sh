termux_step_handle_buildarch() {
	# If $TERMUX_PREFIX already exists, it may have been built for a different arch
	local TERMUX_ARCH_FILE=/data/TERMUX_ARCH
	if [ -f "${TERMUX_ARCH_FILE}" ]; then
		local TERMUX_PREVIOUS_ARCH
		TERMUX_PREVIOUS_ARCH=$(cat $TERMUX_ARCH_FILE)
		if [ "$TERMUX_PREVIOUS_ARCH" != "$TERMUX_ARCH" ]; then
			local TERMUX_DATA_BACKUPDIRS=$TERMUX_TOPDIR/_databackups
			mkdir -p "$TERMUX_DATA_BACKUPDIRS"
			local TERMUX_DATA_PREVIOUS_BACKUPDIR=$TERMUX_DATA_BACKUPDIRS/$TERMUX_PREVIOUS_ARCH
			local TERMUX_DATA_CURRENT_BACKUPDIR=$TERMUX_DATA_BACKUPDIRS/$TERMUX_ARCH
			# Save current /data (removing old backup if any)
			if test -e "$TERMUX_DATA_PREVIOUS_BACKUPDIR"; then
				termux_error_exit "Directory already exists"
			fi
			if [ -d /data/data ]; then
				mv /data/data "$TERMUX_DATA_PREVIOUS_BACKUPDIR"
			fi
			# Restore new one (if any)
			if [ -d "$TERMUX_DATA_CURRENT_BACKUPDIR" ]; then
				mv "$TERMUX_DATA_CURRENT_BACKUPDIR" /data/data
			fi
		fi
	fi

	# Keep track of current arch we are building for.
	echo "$TERMUX_ARCH" > $TERMUX_ARCH_FILE
}
