termux_setup_swift() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local TERMUX_SWIFT_VERSION=$(. $TERMUX_SCRIPTDIR/packages/swift/build.sh; echo $TERMUX_PKG_VERSION)
		local SWIFT_RELEASE=$(. $TERMUX_SCRIPTDIR/packages/swift/build.sh; echo $SWIFT_RELEASE)
		local SWIFT_BIN="swift-$TERMUX_SWIFT_VERSION-$SWIFT_RELEASE-ubuntu20.04"
		local SWIFT_FOLDER

		if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
			SWIFT_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/${SWIFT_BIN}
		else
			SWIFT_FOLDER=${TERMUX_COMMON_CACHEDIR}/${SWIFT_BIN}
		fi

		if [ ! -d "$SWIFT_FOLDER" ]; then
			local SWIFT_TAR=$TERMUX_PKG_TMPDIR/${SWIFT_BIN}.tar.gz
			termux_download \
				https://download.swift.org/swift-$TERMUX_SWIFT_VERSION-release/ubuntu2004/swift-$TERMUX_SWIFT_VERSION-$SWIFT_RELEASE/$SWIFT_BIN.tar.gz \
				$SWIFT_TAR \
				ac1c711985113d0d9daf7bf80205935a0688fb146546690d93c23df54d81cfb7

			(cd $TERMUX_PKG_TMPDIR ; tar xf $SWIFT_TAR ; mv $SWIFT_BIN $SWIFT_FOLDER; rm $SWIFT_TAR)
		fi
		export SWIFT_BINDIR="$SWIFT_FOLDER/usr/bin"
	else
		if [[ "${TERMUX_APP_PACKAGE_MANAGER}" == "apt" ]] && "$(dpkg-query -W -f '${db:Status-Status}\n' swift 2>/dev/null)" != "installed" ||
		   [[ "${TERMUX_APP_PACKAGE_MANAGER}" == "pacman" ]] && ! "$(pacman -Q swift 2>/dev/null)"; then
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
