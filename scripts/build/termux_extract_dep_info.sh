termux_extract_dep_info() {
	package=$1
	if [ ! -d packages/$package ] && [ -f packages/*/${package}.subpackage.sh ]; then
		# We are dealing with a subpackage
		TERMUX_ARCH=$(
			# set TERMUX_SUBPKG_PLATFORM_INDEPENDENT to mother package's value and override if needed
			TERMUX_PKG_PLATFORM_INDEPENDENT=""
			source $(dirname $(find packages/ -name "$package.subpackage.sh"))/build.sh
			TERMUX_SUBPKG_PLATFORM_INDEPENDENT=$TERMUX_PKG_PLATFORM_INDEPENDENT
			source $(find packages/ -name "$package.subpackage.sh")
			if [ "$TERMUX_SUBPKG_PLATFORM_INDEPENDENT" = yes ]; then
				echo all
			else
				echo $TERMUX_ARCH
			fi
		)

		package=$(basename $(dirname $(find packages/ -name "$package.subpackage.sh")))
	elif [ "${package/-dev/}-dev" == "${package}" ]; then
		# dev package
		package=${package/-dev/}
	fi
	(
		# Reset TERMUX_PKG_PLATFORM_INDEPENDENT and TERMUX_PKG_REVISION since these aren't
		# mandatory in a build.sh. Otherwise these will equal the main package's values for
		# deps that should have the default values
		TERMUX_PKG_PLATFORM_INDEPENDENT=""
		TERMUX_PKG_REVISION="0"
		source packages/$package/build.sh
		if [ "$TERMUX_PKG_PLATFORM_INDEPENDENT" = yes ]; then TERMUX_ARCH=all; fi
		if [ "$TERMUX_PKG_REVISION" != "0" ] || [ "$TERMUX_PKG_VERSION" != "${TERMUX_PKG_VERSION/-/}" ]; then
			TERMUX_PKG_VERSION+="-$TERMUX_PKG_REVISION"
		fi
		echo ${TERMUX_ARCH} ${TERMUX_PKG_VERSION}
	)
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	termux_extract_dep_info "$@"
fi
