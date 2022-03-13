termux_setup_nodejs() {
	# Use LTS version for now
	local NODEJS_VERSION=16.14.0
	local NODEJS_FOLDER

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		NODEJS_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/nodejs-${NODEJS_VERSION}
	else
		NODEJS_FOLDER=${TERMUX_COMMON_CACHEDIR}/nodejs-$NODEJS_VERSION
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ ! -x "$NODEJS_FOLDER/bin/node" ]; then
			mkdir -p "$NODEJS_FOLDER"
			local NODEJS_TAR_FILE=$TERMUX_PKG_TMPDIR/nodejs-$NODEJS_VERSION.tar.xz
			termux_download https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.xz \
				"$NODEJS_TAR_FILE" \
				0570b9354959f651b814e56a4ce98d4a067bf2385b9a0e6be075739bc65b0fae
			tar -xf "$NODEJS_TAR_FILE" -C "$NODEJS_FOLDER" --strip-components=1
		fi
		export PATH=$NODEJS_FOLDER/bin:$PATH
	else
		local NODEJS_PKG_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/nodejs/build.sh; echo \$TERMUX_PKG_VERSION")
		if ([ ! -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/nodejs" ] ||
		    [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/nodejs")" != "$NODEJS_PKG_VERSION" ]) &&
		   ([[ "$TERMUX_MAIN_PACKAGE_FORMAT" = "debian" && "$(dpkg-query -W -f '${db:Status-Status}\n' nodejs 2>/dev/null)" != "installed" ]] ||
		    [[ "$TERMUX_MAIN_PACKAGE_FORMAT" = "pacman" && ! "$(pacman -Q nodejs 2>/dev/null)" ]]); then
			echo "Package 'nodejs' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install nodejs"
			echo
			echo "  pacman -S nodejs"
			echo
			echo "or build it from source with"
			echo
			echo "  ./build-package.sh nodejs"
			echo
			exit 1
		fi
	fi
}
