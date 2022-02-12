TERMUX_PKG_HOMEPAGE=https://man7.org/linux/man-pages/man7/sem_overview.7.html
TERMUX_PKG_DESCRIPTION="Shared library for the posix semaphore system function"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS -DPREFIX="\"$TERMUX_PREFIX\"" \
		-c $TERMUX_PKG_BUILDER_DIR/semaphore.c
	$CC $LDFLAGS -shared semaphore.o -o libandroid-posix-semaphore.so
	$AR rcu libandroid-posix-semaphore.a semaphore.o
	cp -f $TERMUX_PKG_BUILDER_DIR/LICENSE $TERMUX_PKG_SRCDIR/
}

termux_step_make_install() {
	install -Dm600 libandroid-posix-semaphore.a $TERMUX_PREFIX/lib/libandroid-posix-semaphore.a
	install -Dm600 libandroid-posix-semaphore.so $TERMUX_PREFIX/lib/libandroid-posix-semaphore.so
}
