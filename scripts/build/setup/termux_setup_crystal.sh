termux_setup_crystal() {
	local CRYSTAL_VERSION=1.2.2
	local CRYSTAL_FOLDER

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		CRYSTAL_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/crystal-${CRYSTAL_VERSION}
	else
		CRYSTAL_FOLDER=${TERMUX_COMMON_CACHEDIR}/crystal-${CRYSTAL_VERSION}
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ ! -x "$CRYSTAL_FOLDER/crystal" ]; then
			mkdir -p "$CRYSTAL_FOLDER"
			local CRYSTAL_TARBALL=$TERMUX_PKG_TMPDIR/crystal-$CRYSTAL_VERSION.tar.gz
			termux_download https://github.com/crystal-lang/crystal/releases/download/$CRYSTAL_VERSION/crystal-${CRYSTAL_VERSION}-1-linux-x86_64-bundled.tar.gz \
				"$CRYSTAL_TARBALL" \
				254f266d547434a00a470347147d0069a905c40b7761b9541d78796d76068450
			tar xf "$CRYSTAL_TARBALL" -C "$CRYSTAL_FOLDER"
		fi
		export PATH=$CRYSTAL_FOLDER:$PATH
	else
		local CRYSTAL_PKG_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/crystal/build.sh; echo \$TERMUX_PKG_VERSION")
		if ([ ! -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/crystal" ] ||
		    [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/crystal")" != "$CRYSTAL_PKG_VERSION" ]) &&
		   [ "$(dpkg-query -W -f '${db:Status-Status}\n' crystal 2>/dev/null)" != "installed" ]; then
			echo "Package 'crystal' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install crystal"
			echo
			echo "or build it from source with"
			echo
			echo "  ./build-package.sh crystal"
			echo
			exit 1
		fi
	fi
}
