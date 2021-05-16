termux_step_create_datatar() {
	if [ "$TERMUX_PKG_METAPACKAGE" = "true" ]; then
		# Metapackage doesn't have data inside.
		rm -rf data
	fi

	tar -cJf "$TERMUX_PKG_PACKAGEDIR/data.tar.xz" -H gnu .
}
