termux_setup_nim() {
	local TERMUX_NIM_VERSION=2.2.6
	local TERMUX_NIM_SHA256=38b8407f87d78bd207390051e4c76f38a45d0a26983cb262017c899b56ad8d06
	local TERMUX_NIM_TARNAME="nim-$TERMUX_NIM_VERSION-linux_x64.tar.xz"
	local TERMUX_NIM_TARFILE="$TERMUX_PKG_TMPDIR/$TERMUX_NIM_TARNAME"
	local TERMUX_NIM_DIR="$TERMUX_COMMON_CACHEDIR/nim-$TERMUX_NIM_VERSION"

	if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == "true" ]]; then
		TERMUX_NIM_DIR="$TERMUX_SCRIPTDIR/build-tools/nim-$TERMUX_NIM_VERSION"
	fi

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		case "$TERMUX_APP_PACKAGE_MANAGER" in
			apt) [[ "$(dpkg-query -W -f '${db:Status-Status}\n' nim 2>/dev/null)" == "installed" ]];;
			pacman)	pacman -Q nim &>/dev/null;;
		esac || termux_error_exit <<-EOL
		Package 'nim' is not installed.
		You can install it with

		  pkg install nim

		  pacman -S nim
		EOL
		return
	fi

	if [[ ! -x "$TERMUX_NIM_DIR" ]]; then
		mkdir -p "$TERMUX_NIM_DIR"
		termux_download "https://nim-lang.org/download/$TERMUX_NIM_TARNAME" \
			"$TERMUX_NIM_TARFILE" \
			"$TERMUX_NIM_SHA256"
		tar xf "$TERMUX_NIM_TARFILE" --strip-components=1 -C "$TERMUX_NIM_DIR"
	fi
	export PATH="$TERMUX_NIM_DIR/bin:$PATH"
}
