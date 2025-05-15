termux_set_package_version_variables() {
	TERMUX_PKG_FULLVERSION="$TERMUX_PKG_VERSION"
	if [ "$TERMUX_PKG_REVISION" != "0" ] || [ "$TERMUX_PKG_FULLVERSION" != "${TERMUX_PKG_FULLVERSION/-/}" ]; then
		# "0" is the default revision, so only include it if the upstream versions contains "-" itself
		TERMUX_PKG_FULLVERSION+="-$TERMUX_PKG_REVISION"
	fi

	TERMUX_PKG_FULLVERSION_FOR_PACMAN=""
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		# Full format version for pacman
		local TERMUX_PKG_VERSION_EDITED="${TERMUX_PKG_VERSION//-/.}"
		local INCORRECT_SYMBOLS
		INCORRECT_SYMBOLS=$(echo "$TERMUX_PKG_VERSION_EDITED" | grep -o '[0-9][a-z]')
		if [ -n "$INCORRECT_SYMBOLS" ]; then
			local TERMUX_PKG_VERSION_EDITED="${TERMUX_PKG_VERSION_EDITED//${INCORRECT_SYMBOLS:0:1}${INCORRECT_SYMBOLS:1:1}/${INCORRECT_SYMBOLS:0:1}.${INCORRECT_SYMBOLS:1:1}}"
		fi
		TERMUX_PKG_FULLVERSION_FOR_PACMAN="${TERMUX_PKG_VERSION_EDITED}"
		if [ -n "$TERMUX_PKG_REVISION" ]; then
			TERMUX_PKG_FULLVERSION_FOR_PACMAN+="-${TERMUX_PKG_REVISION}"
		else
			TERMUX_PKG_FULLVERSION_FOR_PACMAN+="-0"
		fi
	fi

	DEBUG=""
	if [ "$TERMUX_DEBUG_BUILD" = "true" ] && [ "$TERMUX_PKG_HAS_DEBUG" = "true" ]; then
		DEBUG="-dbg"
	fi
}
