termux_setup_ninja() {
	local NINJA_VERSION=1.12.1
	local NINJA_FOLDER

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		NINJA_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/ninja-${NINJA_VERSION}
	else
		NINJA_FOLDER=${TERMUX_COMMON_CACHEDIR}/ninja-$NINJA_VERSION
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ ! -x "$NINJA_FOLDER/ninja" ]; then
			mkdir -p "$NINJA_FOLDER"
			local NINJA_ZIP_FILE=$TERMUX_PKG_TMPDIR/ninja-$NINJA_VERSION.zip
			termux_download https://github.com/ninja-build/ninja/releases/download/v$NINJA_VERSION/ninja-linux.zip \
				"$NINJA_ZIP_FILE" \
				6f98805688d19672bd699fbbfa2c2cf0fc054ac3df1f0e6a47664d963d530255
			unzip "$NINJA_ZIP_FILE" -d "$NINJA_FOLDER"
			chmod 755 $NINJA_FOLDER/ninja
		fi
		export PATH=$NINJA_FOLDER:$PATH
	else
		local NINJA_PKG_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/ninja/build.sh; echo \$TERMUX_PKG_VERSION")
		if ([ ! -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/ninja" ] ||
		    [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/ninja")" != "$NINJA_PKG_VERSION" ]) &&
		   ([[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' ninja 2>/dev/null)" != "installed" ]] ||
		    [[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q ninja 2>/dev/null)" ]]); then
			echo "Package 'ninja' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install ninja"
			echo
			echo "  pacman -S ninja"
			echo
			echo "or build it from source with"
			echo
			echo "  ./build-package.sh ninja"
			echo
			exit 1
		fi
	fi
}
