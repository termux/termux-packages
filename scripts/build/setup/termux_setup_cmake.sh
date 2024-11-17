termux_setup_cmake() {
	local TERMUX_CMAKE_VERSION=3.31.0
	local TERMUX_CMAKE_SHA256=0fcb338b4515044f9ac77543550ac92c314c58f6f95aafcac5cd36aa75db6924
	local TERMUX_CMAKE_MAJORVERSION="${TERMUX_CMAKE_VERSION%.*}"
	local TERMUX_CMAKE_TARNAME="cmake-${TERMUX_CMAKE_VERSION}-linux-x86_64.tar.gz"
	local TERMUX_CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v${TERMUX_CMAKE_VERSION}/${TERMUX_CMAKE_TARNAME}"
	local TERMUX_CMAKE_TARFILE="${TERMUX_PKG_TMPDIR}/${TERMUX_CMAKE_TARNAME}"
	local TERMUX_CMAKE_FOLDER="${TERMUX_COMMON_CACHEDIR}/cmake-${TERMUX_CMAKE_VERSION}"
	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		TERMUX_CMAKE_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/cmake-${TERMUX_CMAKE_VERSION}"
	fi

	if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
		local TERMUX_CMAKE_NAME="cmake"
	elif [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		local TERMUX_CMAKE_NAME="cmake-glibc"
	fi

	export CMAKE_DISABLE_PRECOMPILE_HEADERS=1
	export CMAKE_INSTALL_ALWAYS=1

	if [ "${TERMUX_ON_DEVICE_BUILD}" = "true" ]; then
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' $TERMUX_CMAKE_NAME 2>/dev/null)" != "installed" ]] ||
			[[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q $TERMUX_CMAKE_NAME 2>/dev/null)" ]]; then
			echo "Package '$TERMUX_CMAKE_NAME' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install $TERMUX_CMAKE_NAME"
			echo
			echo "  pacman -S $TERMUX_CMAKE_NAME"
			echo
			exit 1
		fi
		return
	fi

	if [ ! -d "${TERMUX_CMAKE_FOLDER}" ]; then
		termux_download "${TERMUX_CMAKE_URL}" \
			"${TERMUX_CMAKE_TARFILE}" \
			"${TERMUX_CMAKE_SHA256}"
		rm -Rf "${TERMUX_PKG_TMPDIR}/cmake-${TERMUX_CMAKE_VERSION}-linux-x86_64"
		tar xf "${TERMUX_CMAKE_TARFILE}" -C "${TERMUX_PKG_TMPDIR}"
		mv "${TERMUX_PKG_TMPDIR}/cmake-${TERMUX_CMAKE_VERSION}-linux-x86_64" \
			"${TERMUX_CMAKE_FOLDER}"
	fi

	export PATH="${TERMUX_CMAKE_FOLDER}/bin:${PATH}"
}
