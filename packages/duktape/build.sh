TERMUX_PKG_HOMEPAGE=https://www.duktape.org/
TERMUX_PKG_DESCRIPTION="The Duktape JavaScript interpreter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SKIP_SRC_EXTRACT=1
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_extract_package() {
	git clone --depth=1 https://github.com/svaarala/duktape.git -b v${TERMUX_PKG_VERSION} ${TERMUX_PKG_SRCDIR}
}

termux_step_make() {
	make libduktape.so.1.0.0 duk CC=${CC} GXX=${CXX}
}

termux_step_make_install() {
	cp libduktape.so.1.0.0 ${TERMUX_PREFIX}/lib/libduktape.so
	cp duk ${TERMUX_PREFIX}/bin
	cp prep/nondebug/*.h ${TERMUX_PREFIX}/include
}

termux_step_post_make_install() {
	# Add a pkg-config file for the system zlib
	cat > "$PKG_CONFIG_LIBDIR/duktape.pc" <<-HERE
		Name: Duktape
		Description: Shared library for the Duktape interpreter
		Version: $TERMUX_PKG_VERSION
		Requires:
		Libs: -lduktape -lm
	HERE
}
