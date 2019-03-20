termux_extract_dep_info() {
	PKG=$1
	PKG_DIR=$2
	if [ "$PKG" != "$(basename ${PKG_DIR})" ]; then
		# We are dealing with a subpackage
		TERMUX_ARCH=$(
			# set TERMUX_SUBPKG_PLATFORM_INDEPENDENT to parent package's value and override if needed
			TERMUX_PKG_PLATFORM_INDEPENDENT=""
			source ${PKG_DIR}/build.sh
			TERMUX_SUBPKG_PLATFORM_INDEPENDENT=$TERMUX_PKG_PLATFORM_INDEPENDENT
			if [ "$TERMUX_INSTALL_DEPS" = false ] || [ -n "${TERMUX_PKG_NO_DEVELSPLIT}" ] || [ "${PKG/-dev/}-dev" != "${PKG}" ]; then
				source ${PKG_DIR}/${PKG}.subpackage.sh
			fi
			if [ "$TERMUX_SUBPKG_PLATFORM_INDEPENDENT" = yes ]; then
				echo all
			else
				echo $TERMUX_ARCH
			fi
		)

	elif [ "${PKG/-dev/}-dev" == "${PKG}" ]; then
		# dev package
		PKG=${PKG/-dev/}
	fi
	(
		# Reset TERMUX_PKG_PLATFORM_INDEPENDENT and TERMUX_PKG_REVISION since these aren't
		# mandatory in a build.sh. Otherwise these will equal the main package's values for
		# deps that should have the default values
		TERMUX_PKG_PLATFORM_INDEPENDENT=""
		TERMUX_PKG_REVISION="0"
		source ${PKG_DIR}/build.sh
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
