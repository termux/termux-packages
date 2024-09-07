termux_step_finish_build() {
	echo "termux - build of $(test "${TERMUX_VIRTUAL_PKG}" = "true" && echo "virtual") '$TERMUX_PKG_NAME' done"
	test -t 1 && printf "\033]0;%s - DONE\007" "$TERMUX_PKG_NAME"

	if [ "$TERMUX_VIRTUAL_PKG" = "false" ]; then
		mkdir -p "$TERMUX_BUILT_PACKAGES_DIRECTORY"
		echo "$TERMUX_PKG_FULLVERSION" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME"

		for subpackage in "$TERMUX_PKG_BUILDER_DIR"/*.subpackage.sh; do
			local subpkg_name="$(basename $subpackage | sed 's@\.subpackage\.sh@@g')"
			echo "$TERMUX_PKG_FULLVERSION" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/${subpkg_name}"
		done
	fi

	exit 0
}
