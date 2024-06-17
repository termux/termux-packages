#!@TERMUX_PREFIX@/bin/sh
# shellcheck shell=sh

(
	# If termux bootstrap second stage has never been run, like in case
	# bootstrap was extracted to rootfs from a shell instead of by the
	# by the Termux app, which normally runs the second stage, then run it.
	# This is currently an issue of pacman bootstraps, which are not
	# supported by the Termux app and both extraction and second stage
	# are run from a shell. Once support has been added, this script
	# will be removed.
	# Termux app wipes the prefix directory if second stage fails,
	# as otherwise when app is restarted, the broken prefix directory
	# would be used and logged into. We do not do that here as that
	# may wipe other changes done to prefix and users should wipe
	# manually if needed. We do not delete the lock file on failure
	# as then second stage will run again when new shell is started
	# which may affect already configured packages.
	# The shell should still load if second stage run below fails.
	if [ ! -L "@TERMUX_BOOTSTRAP_CONFIG_DIR_PATH@/termux-bootstrap-second-stage.sh.lock" ]; then
		echo "Starting fallback run of termux bootstrap second stage"
		"@TERMUX_BOOTSTRAP_CONFIG_DIR_PATH@/termux-bootstrap-second-stage.sh" || exit $?
	fi

	# Delete script itself so that it is never run again
	rm -f "@TERMUX_PROFILE_D_PREFIX_DIR_PATH@/01-termux-bootstrap-second-stage-fallback.sh" || exit $?

) || return $?
