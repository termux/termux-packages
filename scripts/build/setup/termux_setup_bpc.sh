termux_setup_bpc() {
	local _BPC_BUILD_SH="$TERMUX_SCRIPTDIR/packages/blueprint-compiler/build.sh"
	local _BPC_VERSION=$(bash -c ". $_BPC_BUILD_SH; echo \${TERMUX_PKG_VERSION#*:}")
	local _BPC_SRCURL=$(bash -c ". $_BPC_BUILD_SH; echo \${TERMUX_PKG_SRCURL}")
	local _BPC_SHA256=$(bash -c ". $_BPC_BUILD_SH; echo \${TERMUX_PKG_SHA256}")
	local _BPC_SRCARCHIVE="${TERMUX_PKG_TMPDIR}/bpc-${_BPC_VERSION}.tar.gz"
	local _BPC_SRCDIR="${TERMUX_PKG_TMPDIR}/bpc-${_BPC_VERSION}"
	local _BPC_FOLDER

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		if ([ ! -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/blueprint-compiler" ] ||
			[ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/blueprint-compiler")" != "$_BPC_VERSION" ]) &&
			([[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' blueprint-compiler 2>/dev/null)" != "installed" ]] ||
			[[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q blueprint-compiler 2>/dev/null)" ]]); then
			echo "Package 'blueprint-compiler' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install blueprint-compiler"
			echo
			echo "  pacman -S blueprint-compiler"
			echo
			echo "or build it from source with"
			echo
			echo "  ./build-package.sh blueprint-compiler"
			echo
			exit 1
		fi
		return
	fi

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		_BPC_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/bpc-${_BPC_VERSION}"
	else
		_BPC_FOLDER="${TERMUX_COMMON_CACHEDIR}/bpc-${_BPC_VERSION}"
	fi

	if [ ! -d "$_BPC_FOLDER" ]; then
	(
		termux_download "$_BPC_SRCURL" "$_BPC_SRCARCHIVE" "$_BPC_SHA256"

		rm -Rf "$_BPC_SRCDIR"
		mkdir -p "$_BPC_SRCDIR/build"
		tar -xf "$_BPC_SRCARCHIVE" --strip-components=1 -C "$_BPC_SRCDIR"
		# termux_setup_meson for hostbuilds copied from glib package
		AR=;CC=;CFLAGS=;CPPFLAGS=;CXX=;CXXFLAGS=;LD=;LDFLAGS=;PKG_CONFIG=;STRIP=
		termux_setup_meson
		unset AR CC CFLAGS CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG STRIP
		${TERMUX_MESON} setup "$_BPC_SRCDIR" "$_BPC_SRCDIR/build" --prefix "$_BPC_FOLDER"
		ninja -C "$_BPC_SRCDIR/build" -j "$TERMUX_PKG_MAKE_PROCESSES"
		ninja -C "$_BPC_SRCDIR/build" install
	)
	fi

	export PATH="$_BPC_FOLDER/bin:$PATH"
	export GI_TYPELIB_PATH="$TERMUX_PREFIX/lib/girepository-1.0"
}
