termux_step_cleanup_packages() {
	[[ "${TERMUX_CLEANUP_BUILT_PACKAGES_ON_LOW_DISK_SPACE:=false}" == "true" ]] || return 0
	[[ -d "$TERMUX_TOPDIR" ]] || return 0

	# How much space is considered to be enough
	local CLEANUP_THRESHOLD="$(( 5 * 1024 ** 3 ))" # 5 GiB

	# Extract available disk space in bytes
	local AVAILABLE="$(df "$TERMUX_TOPDIR" | awk 'NR==2 {print $4 * 1024}')"

	# No need to cleanup if there is enough disk space
	(( AVAILABLE <= CLEANUP_THRESHOLD )) || return 0

	local TERMUX_PACKAGES_DIRECTORIES="$(jq --raw-output 'del(.pkg_format) | keys | .[]' "${TERMUX_SCRIPTDIR}"/repo.json)"

	# Build package name regex to be used with `find`, avoiding loops.
	local PKG_REGEX="$(find ${TERMUX_PACKAGES_DIRECTORIES} -mindepth 1 -maxdepth 1 -type d -printf '%f|')^$"

	# Exclude current package from the list.
	PKG_REGEX="${PKG_REGEX//$TERMUX_PKG_NAME|/}"

	echo "INFO: cleaning up some disk space for building \"${TERMUX_PKG_NAME}\"."

	find "$TERMUX_TOPDIR" -mindepth 1 -maxdepth 1 -type d -regextype posix-extended -regex ".*/($PKG_REGEX)$" -exec rm -rf {} +
}
