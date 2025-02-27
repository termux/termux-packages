termux_step_cleanup_packages() {
	[[ -d "$TERMUX_TOPDIR" ]] || return 0

	# Extract available disk space in GB
	local AVAILABLE=`df -B $((1024**3)) --output=avail "$TERMUX_TOPDIR" | tail -1`

	# No need to cleanup if there is enough disk space (more than 5 GB)
	[ "$AVAILABLE" -lt 5 ] || return 0

	local TERMUX_PACKAGES_DIRECTORIES="$(jq --raw-output 'del(.pkg_format) | keys | .[]' "${TERMUX_SCRIPTDIR}"/repo.json)"

	# Build package name regex to be used with `find`, avoiding loops.
	local PKG_REGEX="$(find ${TERMUX_PACKAGES_DIRECTORIES} -mindepth 1 -maxdepth 1 -type d -printf '%f|')^$"

	# Exclude current package from the list.
	PKG_REGEX="${PKG_REGEX//$TERMUX_PKG_NAME|/}"

	echo "INFO: cleaning up some disk space for building \"${TERMUX_PKG_NAME}\"."

	find "$TERMUX_TOPDIR" -mindepth 1 -maxdepth 1 -type d -regextype posix-extended -regex ".*/($PKG_REGEX)$" -exec rm -rf {} +
}
