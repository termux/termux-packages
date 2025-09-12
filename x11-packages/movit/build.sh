TERMUX_PKG_HOMEPAGE=https://movit.sesse.net/
TERMUX_PKG_DESCRIPTION="The modern video toolkit"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION="1.7.2"
TERMUX_PKG_SRCURL=https://movit.sesse.net/movit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=00ac1f8e46c2d3e38c75cbb7a1af0a615751c158c611cb70053094b65ecfe8d5
TERMUX_PKG_DEPENDS="fftw, libepoxy"
TERMUX_PKG_BUILD_DEPENDS="eigen, googletest, sdl2"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static"
TERMUX_PKG_EXTRA_MAKE_ARGS="TESTS="

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/make_bundled_shaders.py $TERMUX_PKG_SRCDIR/
	chmod +x $TERMUX_PKG_SRCDIR/make_bundled_shaders.py
}

termux_step_pre_configure() {
	# fix arm build and potentially other archs hidden bugs
	# ERROR: ./lib/libmovit.so contains undefined symbols:
	#     69: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_uidiv
	#    120: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_idiv
	#    155: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_ul2d
	#    205: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_uidivmod
	#    217: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_idivmod
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	autoreconf -fi
}
