TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="A getpass(3) implementation"
TERMUX_PKG_VERSION=0.1

termux_step_make_install () {
	$CC $CFLAGS $CPPFLAGS $LDFLAGS -Wall -Wextra -fPIC -shared $TERMUX_PKG_BUILDER_DIR/getpass.c -o $TERMUX_PREFIX/lib/libgetpass.so
}
