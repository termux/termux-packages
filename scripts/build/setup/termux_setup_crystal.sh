termux_setup_crystal() {
	local TERMUX_CRYSTAL_VERSION=1.12.0
	local TERMUX_CRYSTAL_SHA256=d0c9237e8f0bb8c176545019b2296b65451fb29e2b4c7585986a3f9a4bcc1cb3
	local TERMUX_CRYSTAL_TARNAME=crystal-${TERMUX_CRYSTAL_VERSION}-1-linux-x86_64-bundled.tar.gz
	local TERMUX_CRYSTAL_TARFILE=$TERMUX_PKG_TMPDIR/crystal-$TERMUX_CRYSTAL_VERSION.tar.gz
	local TERMUX_CRYSTAL_FOLDER

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		TERMUX_CRYSTAL_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/crystal-${TERMUX_CRYSTAL_VERSION}
	else
		TERMUX_CRYSTAL_FOLDER=${TERMUX_COMMON_CACHEDIR}/crystal-${TERMUX_CRYSTAL_VERSION}
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ ! -x "$TERMUX_CRYSTAL_FOLDER" ]; then
			mkdir -p "$TERMUX_CRYSTAL_FOLDER"
			termux_download "https://github.com/crystal-lang/crystal/releases/download/$TERMUX_CRYSTAL_VERSION/$TERMUX_CRYSTAL_TARNAME" \
				"$TERMUX_CRYSTAL_TARFILE" \
				"$TERMUX_CRYSTAL_SHA256"
			tar xf "$TERMUX_CRYSTAL_TARFILE" --strip-components=2 -C "$TERMUX_CRYSTAL_FOLDER"
		fi
		export PATH=$TERMUX_CRYSTAL_FOLDER/bin:$PATH
	else
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' crystal 2>/dev/null)" != "installed" ]] ||
                   [[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q crystal 2>/dev/null)" ]]; then
			echo "Package 'crystal' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install crystal"
			echo
			echo "  pacman -S crystal"
			echo
			exit 1
		fi
	fi
}
