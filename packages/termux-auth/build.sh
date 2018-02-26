TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="Shared library for the glob(3) system function"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/termux-auth.h $TERMUX_PREFIX/include/
	$CC $CFLAGS $CPPFLAGS $LDFLAGS -lcrypto $TERMUX_PKG_BUILDER_DIR/termux-auth.c -shared -o $TERMUX_PREFIX/lib/libtermux-auth.so
	$CC $CFLAGS $CPPFLAGS $LDFLAGS -lcrypto -ltermux-auth $TERMUX_PKG_BUILDER_DIR/passwd.c -o $TERMUX_PREFIX/bin/passwd
	$CC $CFLAGS $CPPFLAGS $LDFLAGS -lcrypto -ltermux-auth $TERMUX_PKG_BUILDER_DIR/test.c -o $TERMUX_PREFIX/bin/termux-auth-test
}
