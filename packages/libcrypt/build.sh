TERMUX_PKG_HOMEPAGE=http://michael.dipperstein.com/crypt/
TERMUX_PKG_DESCRIPTION="A crypt(3) implementation"
TERMUX_PKG_VERSION=0.1

termux_step_make_install () {
	$CC $CFLAGS $LDFLAGS -fPIC -shared $TERMUX_PKG_BUILDER_DIR/crypt3.c -o $TERMUX_PREFIX/lib/libcrypt.so
	mkdir -p $TERMUX_PREFIX/include/
	cp $TERMUX_PKG_BUILDER_DIR/crypt.h $TERMUX_PREFIX/include/
}
