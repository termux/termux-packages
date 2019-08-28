TERMUX_PKG_HOMEPAGE=http://man7.org/linux/man-pages/man3/posix_spawn.3.html
TERMUX_PKG_DESCRIPTION="Shared library for the posix_spawn system function"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS -I$TERMUX_PKG_BUILDER_DIR -c $TERMUX_PKG_BUILDER_DIR/posix_spawn.c
	$CC $LDFLAGS -shared posix_spawn.o -o libandroid-spawn.so
	$AR rcu libandroid-spawn.a posix_spawn.o
}

termux_step_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/posix_spawn.h $TERMUX_PREFIX/include/spawn.h
	install -Dm600 libandroid-spawn.a $TERMUX_PREFIX/lib/libandroid-spawn.a
	install -Dm600 libandroid-spawn.so $TERMUX_PREFIX/lib/libandroid-spawn.so
}
