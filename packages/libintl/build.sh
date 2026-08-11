TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="POSIX gettext libintl implementation for Android Bionic"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS -fPIC -shared \
		$TERMUX_PKG_BUILDER_DIR/src/libintl.c \
		-o $TERMUX_PKG_BUILDDIR/libintl.so $LDFLAGS
}

termux_step_make_install() {
	install -Dm755 $TERMUX_PKG_BUILDDIR/libintl.so $TERMUX_PREFIX/lib/libintl.so
	install -Dm644 $TERMUX_PKG_BUILDER_DIR/src/libintl.h $TERMUX_PREFIX/include/libintl.h
}
