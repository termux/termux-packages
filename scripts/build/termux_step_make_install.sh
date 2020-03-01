termux_step_make_install() {
	if [ $TERMUX_ON_DEVICE_BUILD = "true" ]; then
		CHROOT="termux-build-chroot"
        	MAKE_INSTALL_TOOLS="sed grep mkdir install"
		# We need to symlink some tools into our new prefix
		for tool in $MAKE_INSTALL_TOOLS; do
			mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin
			ln -s /usr/bin/$tool $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin/
		done
	else
		CHROOT=""
	fi
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	if test -f build.ninja; then
		$CHROOT ninja -w dupbuild=warn -j $TERMUX_MAKE_PROCESSES install
	elif ls ./*akefile &> /dev/null || [ -n "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
		: "${TERMUX_PKG_MAKE_INSTALL_TARGET:="install"}"
		# Some packages have problem with parallell install, and it does not buy much, so use -j 1.
		echo "Running $CHROOT make -j 1 ${TERMUX_PKG_EXTRA_MAKE_ARGS} ${TERMUX_PKG_MAKE_INSTALL_TARGET}"
		if [ -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
			$CHROOT make -j 1 ${TERMUX_PKG_MAKE_INSTALL_TARGET}
		else
			$CHROOT make -j 1 ${TERMUX_PKG_EXTRA_MAKE_ARGS} ${TERMUX_PKG_MAKE_INSTALL_TARGET}
		fi
	elif test -f Cargo.toml; then
		termux_setup_rust
		$CHROOT cargo install \
			--jobs $TERMUX_MAKE_PROCESSES \
			--path . \
			--force \
			--target $CARGO_TARGET_NAME \
			--root $TERMUX_PREFIX \
			$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
		# https://github.com/rust-lang/cargo/issues/3316:
		$CHROOT rm -f $TERMUX_PREFIX/.crates.toml
		$CHROOT rm -f $TERMUX_PREFIX/.crates2.json
	fi
	if [ $TERMUX_ON_DEVICE_BUILD = "true" ]; then
		for tool in $MAKE_INSTALL_TOOLS; do
			unlink $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin/$tool
		done
	fi
}
