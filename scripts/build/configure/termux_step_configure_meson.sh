termux_step_configure_meson() {
	termux_setup_meson
	CC=gcc CXX=g++ CFLAGS= CXXFLAGS= CPPFLAGS= LDFLAGS= $TERMUX_MESON \
		$TERMUX_PKG_SRCDIR \
		$TERMUX_PKG_BUILDDIR \
		--cross-file $TERMUX_MESON_CROSSFILE \
		--prefix $TERMUX_PREFIX \
		--libdir lib \
		--buildtype minsize \
		--strip \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}
