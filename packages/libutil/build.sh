TERMUX_PKG_HOMEPAGE=https://refspecs.linuxbase.org/LSB_2.1.0/LSB-generic/LSB-generic/libutil.html
TERMUX_PKG_DESCRIPTION="Library with terminal functions"
TERMUX_PKG_VERSION=0.3
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install () {
	CPPFLAGS+=" -std=c11 -Wall -Werror"
	$CC $CPPFLAGS $CFLAGS -c -fPIC $TERMUX_PKG_BUILDER_DIR/pty.c -o pty.o
	$CC -shared -fPIC $LDFLAGS -o $TERMUX_PREFIX/lib/libutil.so pty.o
}
