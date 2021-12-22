termux_step_finish_build() {
	echo "termux - build of '$TERMUX_PKG_NAME' done"
	test -t 1 && printf "\033]0;%s - DONE\007" "$TERMUX_PKG_NAME"

	mkdir -p "$TERMUX_BUILT_PACKAGES_DIRECTORY"
	echo "$TERMUX_PKG_FULLVERSION" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME"

	exit 0
}
