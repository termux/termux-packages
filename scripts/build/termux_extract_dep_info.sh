termux_extract_dep_info() {
	PKG=$1
	PKG_DIR=$2
	if [ "$PKG" != "$(basename ${PKG_DIR})" ]; then
		# We are dealing with a subpackage
		TERMUX_ARCH=$(
			# set TERMUX_SUBPKG_PLATFORM_INDEPENDENT to
			# parent package's value and override if
			# needed
			TERMUX_PKG_PLATFORM_INDEPENDENT=false
			source ${PKG_DIR}/build.sh
			TERMUX_SUBPKG_PLATFORM_INDEPENDENT=$TERMUX_PKG_PLATFORM_INDEPENDENT
			if [ "$TERMUX_INSTALL_DEPS" = "false" ] || \
				   [ "$TERMUX_PKG_NO_STATICSPLIT" = "true" ] || \
				   [ "${PKG/-static/}-static" != "${PKG}" ]; then
				source ${PKG_DIR}/${PKG}.subpackage.sh
			fi
			if [ "$TERMUX_SUBPKG_PLATFORM_INDEPENDENT" = "true" ]; then
				echo all
			else
				echo $TERMUX_ARCH
			fi
		)
	else
		TERMUX_ARCH=$(
			TERMUX_PKG_PLATFORM_INDEPENDENT="false"
			source ${PKG_DIR}/build.sh
			if [ "$TERMUX_PKG_PLATFORM_INDEPENDENT" = "true" ]; then
				echo all
			else
				echo $TERMUX_ARCH
			fi
		)
	fi
	(
		# debian version
		TERMUX_PKG_REVISION="0"
		source ${PKG_DIR}/build.sh
		if [ "$TERMUX_PKG_REVISION" != "0" ] || \
			   [ "$TERMUX_PKG_VERSION" != "${TERMUX_PKG_VERSION/-/}" ]; then
			TERMUX_PKG_VERSION+="-$TERMUX_PKG_REVISION"
		fi
		echo -n "${TERMUX_ARCH} ${TERMUX_PKG_VERSION} "
	)
	(
		# pacman version
		TERMUX_PKG_REVISION="0"
		source ${PKG_DIR}/build.sh
		TERMUX_PKG_VERSION_EDITED=${TERMUX_PKG_VERSION//-/.}
		INCORRECT_SYMBOLS=$(echo $TERMUX_PKG_VERSION_EDITED | grep -o '[0-9][a-z]')
		if [ -n "$INCORRECT_SYMBOLS" ]; then
			TERMUX_PKG_VERSION_EDITED=${TERMUX_PKG_VERSION_EDITED//${INCORRECT_SYMBOLS:0:1}${INCORRECT_SYMBOLS:1:1}/${INCORRECT_SYMBOLS:0:1}.${INCORRECT_SYMBOLS:1:1}}
		fi
		echo "${TERMUX_PKG_VERSION_EDITED}-${TERMUX_PKG_REVISION}"
	)
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	termux_extract_dep_info "$@"
fi
