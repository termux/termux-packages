# Utility function to setup a GHC toolchain.
termux_setup_ghc() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local TERMUX_GHC_VERSION=8.10.1
		local TERMUX_GHC_TEMP_FOLDER="${TERMUX_COMMON_CACHEDIR}/ghc-${TERMUX_GHC_VERSION}"
		local TERMUX_GHC_TAR="${TERMUX_GHC_TEMP_FOLDER}.tar.xz"
		local TERMUX_GHC_RUNTIME_FOLDER

		if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
			TERMUX_GHC_RUNTIME_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/ghc-${TERMUX_GHC_VERSION}-runtime"
		else
			TERMUX_GHC_RUNTIME_FOLDER="${TERMUX_COMMON_CACHEDIR}/ghc-${TERMUX_GHC_VERSION}-runtime"
		fi

		export PATH="$TERMUX_GHC_RUNTIME_FOLDER/bin:$PATH"

		if [ -d "$TERMUX_GHC_RUNTIME_FOLDER" ]; then return; fi

		termux_download "https://downloads.haskell.org/~ghc/${TERMUX_GHC_VERSION}/ghc-${TERMUX_GHC_VERSION}-x86_64-deb10-linux.tar.xz" \
			"$TERMUX_GHC_TAR" \
			c1e31d798b013699b3c0de4fda27fb4cda47f572df0e75e3bd598a3012060615

		rm -Rf "$TERMUX_GHC_TEMP_FOLDER"
		tar xf "$TERMUX_GHC_TAR" -C "$TERMUX_COMMON_CACHEDIR"

		(set -e
			unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP
			cd "$TERMUX_GHC_TEMP_FOLDER"
			./configure --prefix="$TERMUX_GHC_RUNTIME_FOLDER"
			make install
		)

		rm -Rf "$TERMUX_GHC_TEMP_FOLDER"
	else
		if [[ "$TERMUX_MAIN_PACKAGE_FORMAT" = "debian" && "$(dpkg-query -W -f '${db:Status-Status}\n' ghc 2>/dev/null)" != "installed" ]] ||
                   [[ "$TERMUX_MAIN_PACKAGE_FORMAT" = "pacman" && ! "$(pacman -Q ghc 2>/dev/null)" ]]; then
			echo "Package 'ghc' is not installed."
			exit 1
		fi
	fi
}
