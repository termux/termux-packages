TERMUX_PKG_HOMEPAGE=http://man7.org/linux/man-pages/man3/glob.3.html
TERMUX_PKG_DESCRIPTION="Shared library for the glob(3) system function"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=0.4
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install() {
	cp $TERMUX_PKG_BUILDER_DIR/glob.h $TERMUX_PREFIX/include/
	$CC $CFLAGS $CPPFLAGS $LDFLAGS $TERMUX_PKG_BUILDER_DIR/glob.c -shared -o $TERMUX_PREFIX/lib/libandroid-glob.so
}
