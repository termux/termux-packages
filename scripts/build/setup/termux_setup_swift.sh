termux_setup_swift() {
	local SWIFT_TRIPLE=${TERMUX_HOST_PLATFORM/-/-unknown-}$TERMUX_PKG_API_LEVEL
	export SWIFT_TARGET_TRIPLE=${SWIFT_TRIPLE/arm-/armv7-}

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local TERMUX_SWIFT_VERSION=$(. $TERMUX_SCRIPTDIR/packages/swift/build.sh; echo $TERMUX_PKG_VERSION)
		local SWIFT_RELEASE=$(. $TERMUX_SCRIPTDIR/packages/swift/build.sh; echo $SWIFT_RELEASE)
		local SWIFT_BIN="swift-$TERMUX_SWIFT_VERSION-$SWIFT_RELEASE-ubuntu22.04"
		local SWIFT_FOLDER

		if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
			SWIFT_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/${SWIFT_BIN}
		else
			SWIFT_FOLDER=${TERMUX_COMMON_CACHEDIR}/${SWIFT_BIN}
		fi

		if [ ! -d "$SWIFT_FOLDER" ]; then
			local SWIFT_TAR=$TERMUX_PKG_TMPDIR/${SWIFT_BIN}.tar.gz
			termux_download \
				https://download.swift.org/swift-$TERMUX_SWIFT_VERSION-release/ubuntu2204/swift-$TERMUX_SWIFT_VERSION-$SWIFT_RELEASE/$SWIFT_BIN.tar.gz \
				$SWIFT_TAR \
				e729912846b0cff98bf8e0e5ede2e17bc2d1098de3cdb6fa13b3ff52c36ee5d6

			(cd $TERMUX_PKG_TMPDIR ; tar xf $SWIFT_TAR ; mv $SWIFT_BIN $SWIFT_FOLDER; rm $SWIFT_TAR)
		fi
		export SWIFT_BINDIR="$SWIFT_FOLDER/usr/bin"
		export SWIFT_CROSSCOMPILE_CONFIG="$SWIFT_FOLDER/usr/android-$TERMUX_ARCH.json"
		if [ ! -z ${TERMUX_STANDALONE_TOOLCHAIN+x} ]; then
			cat <<- EOF > $SWIFT_CROSSCOMPILE_CONFIG
			{ "version": 1,
			"target": "${SWIFT_TARGET_TRIPLE}",
			"toolchain-bin-dir": "${SWIFT_BINDIR}",
			"sdk": "${TERMUX_STANDALONE_TOOLCHAIN}/sysroot",
			"extra-cc-flags": [ "-fPIC" ],
			"extra-swiftc-flags": [ "-resource-dir", "${TERMUX_PREFIX}/lib/swift",
			   "-Xcc", "-I${TERMUX_PREFIX}/include",
			   "-L${TERMUX_PREFIX}/lib",
			   "-tools-directory", "${TERMUX_STANDALONE_TOOLCHAIN}/bin", ],
			"extra-cpp-flags": [ "-lstdc++" ] }
			EOF
		fi
	else
		if [[ "${TERMUX_APP_PACKAGE_MANAGER}" == "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' swift 2>/dev/null)" != "installed" ]] ||
		   [[ "${TERMUX_APP_PACKAGE_MANAGER}" == "pacman" && ! "$(pacman -Q swift 2>/dev/null)" ]]; then
			echo "Package 'swift' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install swift"
			echo
			echo "  pacman -S swift"
			echo
			echo "or build it from source with"
			echo
			echo "  ./build-package.sh swift"
			echo
			exit 1
		fi
		export SWIFT_BINDIR="$TERMUX_PREFIX/bin"
	fi
}
