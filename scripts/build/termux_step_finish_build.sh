termux_step_finish_build() {
	echo "Extracting ${TERMUX_PKG_DEBFILE} into $TERMUX_PREFIX"
	(
		cd $TERMUX_COMMON_CACHEDIR-$TERMUX_ARCH
		ar x ${TERMUX_PKG_DEBFILE} data.tar.xz
		if tar -tf data.tar.xz|grep "^./$">/dev/null; then
			# Strip prefixed ./, to avoid possible
			# permission errors from tar
			tar -xf data.tar.xz --strip-components=1 \
				--no-overwrite-dir -C /
		else
			tar -xf data.tar.xz --no-overwrite-dir -C /
		fi
	)

	echo "termux - build of '$TERMUX_PKG_NAME' done"
	test -t 1 && printf "\033]0;%s - DONE\007" "$TERMUX_PKG_NAME"

	mkdir -p "$TERMUX_BUILT_PACKAGES_DIRECTORY"
	echo "$TERMUX_PKG_FULLVERSION" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME"

	exit 0
}
