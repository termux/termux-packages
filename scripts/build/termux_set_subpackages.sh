termux_set_subpackages() {
	local skip_create_virtual_static_subpackage_file="$1"
	TERMUX_PKG_SUBPACKAGES_LIST=()

	local _ADD_PREFIX=""
	if [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		_ADD_PREFIX="glibc/"
	fi

	if [ "$TERMUX_PKG_NO_STATICSPLIT" = "false" ] &&
		[[ -n "$(cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"; shopt -s globstar; shopt -s nullglob; echo ${_ADD_PREFIX}lib{,32}/**/*.a)" ]]; then
		# Add virtual static subpackage if there are include files:
		local _STATIC_SUBPACKAGE_FILE="$TERMUX_PKG_TMPDIR/${TERMUX_PKG_NAME}-static.subpackage.sh"
		echo "Creating ${TERMUX_PKG_NAME}-static.subpackage.sh"
		TERMUX_PKG_SUBPACKAGES_LIST+=("$_STATIC_SUBPACKAGE_FILE")
		if [ "$skip_create_virtual_static_subpackage_file" != "true" ]; then
			(
				cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX" &&
				echo TERMUX_SUBPKG_INCLUDE=\"$(find ${_ADD_PREFIX}lib{,32} -name '*.a' -o -name '*.la' 2> /dev/null) $TERMUX_PKG_STATICSPLIT_EXTRA_PATTERNS\" > "$_STATIC_SUBPACKAGE_FILE"
				echo "TERMUX_SUBPKG_DESCRIPTION=\"Static libraries for ${TERMUX_PKG_NAME}\"" >> "$_STATIC_SUBPACKAGE_FILE"
			)
		fi
	fi

	# Add all predefined subpackages in package directory
	for subpackage in $(find "$TERMUX_PKG_BUILDER_DIR" -maxdepth 1 -type f -name "*.subpackage.sh" | sort); do
		TERMUX_PKG_SUBPACKAGES_LIST+=("$subpackage")
	done
}
