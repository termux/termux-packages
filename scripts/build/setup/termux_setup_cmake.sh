termux_setup_cmake() {
	local TERMUX_CMAKE_MAJORVESION=3.23
	local TERMUX_CMAKE_MINORVERSION=2
	local TERMUX_CMAKE_VERSION=$TERMUX_CMAKE_MAJORVESION.$TERMUX_CMAKE_MINORVERSION
	local TERMUX_CMAKE_TARNAME=cmake-${TERMUX_CMAKE_VERSION}-linux-x86_64.tar.gz
	local TERMUX_CMAKE_TARFILE=$TERMUX_PKG_TMPDIR/$TERMUX_CMAKE_TARNAME
	local TERMUX_CMAKE_FOLDER

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		TERMUX_CMAKE_FOLDER=$TERMUX_SCRIPTDIR/build-tools/cmake-$TERMUX_CMAKE_VERSION
	else
		TERMUX_CMAKE_FOLDER=$TERMUX_COMMON_CACHEDIR/cmake-$TERMUX_CMAKE_VERSION
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ ! -d "$TERMUX_CMAKE_FOLDER" ]; then
			termux_download https://cmake.org/files/v$TERMUX_CMAKE_MAJORVESION/$TERMUX_CMAKE_TARNAME \
				"$TERMUX_CMAKE_TARFILE" \
				aaced6f745b86ce853661a595bdac6c5314a60f8181b6912a0a4920acfa32708
			rm -Rf "$TERMUX_PKG_TMPDIR/cmake-${TERMUX_CMAKE_VERSION}-linux-x86_64"
			tar xf "$TERMUX_CMAKE_TARFILE" -C "$TERMUX_PKG_TMPDIR"
			mv "$TERMUX_PKG_TMPDIR/cmake-${TERMUX_CMAKE_VERSION}-linux-x86_64" \
				"$TERMUX_CMAKE_FOLDER"
		fi

		export PATH=$TERMUX_CMAKE_FOLDER/bin:$PATH
	else
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' cmake 2>/dev/null)" != "installed" ]] ||
                   [[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q cmake 2>/dev/null)" ]]; then
			echo "Package 'cmake' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install cmake"
			echo
			echo "  pacman -S cmake"
			echo
			exit 1
		fi
	fi

	export CMAKE_INSTALL_ALWAYS=1
}
