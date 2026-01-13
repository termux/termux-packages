termux_setup_nodejs() {
	export NODE_OPTIONS=""
	# This should not be needed when we update nodejs version to v26
	# This is the default from v25.2.0 onwards, and first LTS having it will be v26
	# Ref: https://github.com/nodejs/node/commit/506b79e888
	NODE_OPTIONS+=" --network-family-autoselection-attempt-timeout=500"
	# Use LTS version for now
	local NODEJS_VERSION=22.22.0
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
				9aa8e9d2298ab68c600bd6fb86a6c13bce11a4eca1ba9b39d79fa021755d7c37
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
