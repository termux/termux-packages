termux_step_cleanup_packages() {
	[[ "${TERMUX_CLEANUP_BUILT_PACKAGES_ON_LOW_DISK_SPACE:=false}" == "true" ]] || return 0
	[[ -d "$TERMUX_TOPDIR" ]] || return 0

	local AVAILABLE TERMUX_PACKAGES_DIRECTORIES PKGS PKG_REGEX

	# Extract available disk space in bytes
	AVAILABLE="$(df "$TERMUX_TOPDIR" | awk 'NR==2 {print $4 * 1024}')"

	# No need to cleanup if there is enough disk space
	(( AVAILABLE <= TERMUX_CLEANUP_BUILT_PACKAGES_THRESHOLD )) || return 0

	TERMUX_PACKAGES_DIRECTORIES="$(jq --raw-output 'del(.pkg_format) | keys | .[]' "${TERMUX_SCRIPTDIR}"/repo.json)"

	# Build package name regex to be used with `find`, avoiding loops.
	PKGS="$(find ${TERMUX_PACKAGES_DIRECTORIES} -mindepth 1 -maxdepth 1 -type d -printf '%f\n')"
	[[ -z "$PKGS" ]] && return 0

	# Exclude current package from the list.
	PKGS="$(printf "%s" "$PKGS" | grep -Fxv "$TERMUX_PKG_NAME")"
	[[ -z "$PKGS" ]] && return 0

	PKG_REGEX="$(printf "%s" "$PKGS" | sed -zE 's/[][\.|$(){}?+*^]/\\&/g' | sed -E 's/(.*)/(\1)/g' | sed -zE -e 's/[\n]+/|/g' -e 's/(.*)/(\1)/g')"

	echo "INFO: cleaning up some disk space for building \"${TERMUX_PKG_NAME}\"."

	(cd "$TERMUX_TOPDIR" && find . -mindepth 1 -maxdepth 1 -type d -regextype posix-extended -regex "^\./$PKG_REGEX$" -exec rm -rf "{}" +)
}
