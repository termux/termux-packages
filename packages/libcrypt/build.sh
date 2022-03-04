TERMUX_PKG_HOMEPAGE=http://michael.dipperstein.com/crypt/
TERMUX_PKG_DESCRIPTION="A crypt(3) implementation"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2
TERMUX_PKG_REVISION=5
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BREAKS="libcrypt-dev"
TERMUX_PKG_REPLACES="libcrypt-dev"

termux_step_make_install() {
	$CC $CFLAGS $CPPFLAGS $LDFLAGS -Wall -Wextra -fPIC -shared $TERMUX_PKG_BUILDER_DIR/crypt3.c -lcrypto -o $TERMUX_PREFIX/lib/libcrypt.so
	mkdir -p $TERMUX_PREFIX/include/
	cp $TERMUX_PKG_BUILDER_DIR/crypt.h $TERMUX_PREFIX/include/
	cp $TERMUX_PKG_BUILDER_DIR/LICENSE $TERMUX_PKG_SRCDIR/
}
