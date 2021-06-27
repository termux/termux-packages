TERMUX_PKG_HOMEPAGE=https://man7.org/linux/man-pages/man3/wordexp.3.html
TERMUX_PKG_DESCRIPTION="Shared library for the wordexp(3) system function"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS -I$TERMUX_PKG_BUILDER_DIR -c $TERMUX_PKG_BUILDER_DIR/wordexp.c
	$CC $LDFLAGS -shared wordexp.o -o libandroid-wordexp.so
	$AR rcu libandroid-wordexp.a wordexp.o
}

termux_step_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/wordexp.h $TERMUX_PREFIX/include/wordexp.h
	install -Dm600 libandroid-wordexp.a $TERMUX_PREFIX/lib/libandroid-wordexp.a
	install -Dm600 libandroid-wordexp.so $TERMUX_PREFIX/lib/libandroid-wordexp.so
}
