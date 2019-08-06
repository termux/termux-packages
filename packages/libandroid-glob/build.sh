TERMUX_PKG_HOMEPAGE=http://man7.org/linux/man-pages/man3/glob.3.html
TERMUX_PKG_DESCRIPTION="Shared library for the glob(3) system function"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=0.6
TERMUX_PKG_BREAKS="libandroid-glob-dev"
TERMUX_PKG_REPLACES="libandroid-glob-dev"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS -I$TERMUX_PKG_BUILDER_DIR -c $TERMUX_PKG_BUILDER_DIR/glob.c
	$CC $LDFLAGS -shared glob.o -o libandroid-glob.so
	$AR rcu libandroid-glob.a glob.o
}

termux_step_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/glob.h $TERMUX_PREFIX/include/glob.h
	install -Dm600 libandroid-glob.a $TERMUX_PREFIX/lib/libandroid-glob.a
	install -Dm600 libandroid-glob.so $TERMUX_PREFIX/lib/libandroid-glob.so
}
