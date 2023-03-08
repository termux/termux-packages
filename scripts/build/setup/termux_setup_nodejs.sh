termux_setup_nodejs() {
	# Use LTS version for now
	local NODEJS_VERSION=18.15.0
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
				c8c5fa53ce0c0f248e45983e86368e0b1daf84b77e88b310f769c3cfc12682ef
			tar -xf "$NODEJS_TAR_FILE" -C "$NODEJS_FOLDER" --strip-components=1
		fi
		export PATH=$NODEJS_FOLDER/bin:$PATH
	else
		local NODEJS_PKG_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/nodejs/build.sh; echo \$TERMUX_PKG_VERSION")
		if ([ ! -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/nodejs" ] ||
		    [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/nodejs")" != "$NODEJS_PKG_VERSION" ]) &&
		   ([[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' nodejs 2>/dev/null)" != "installed" ]] ||
		    [[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q nodejs 2>/dev/null)" ]]); then
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
