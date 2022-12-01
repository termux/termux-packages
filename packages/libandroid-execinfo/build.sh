TERMUX_PKG_HOMEPAGE=https://man7.org/linux/man-pages/man3/backtrace.3.html
TERMUX_PKG_DESCRIPTION="Shared library for the backtrace system function"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PROVIDES="libexecinfo"
TERMUX_PKG_CONFLICTS="libexecinfo"

# Files are taken from the Bionic libc repo. 
# exexinfo.h: https://android.googlesource.com/platform/bionic/+/refs/heads/master/libc/include/execinfo.h
# execinfo.c: https://android.googlesource.com/platform/bionic/+/refs/heads/master/libc/bionic/execinfo.cpp
termux_step_make() {
	$CC $CFLAGS -I$TERMUX_PKG_BUILDER_DIR -c $TERMUX_PKG_BUILDER_DIR/execinfo.c
	$CC $LDFLAGS -shared execinfo.o -o libandroid-execinfo.so \
		-Wl,-soname=libandroid-execinfo.so
	$AR rcu libandroid-execinfo.a execinfo.o
	cp -f $TERMUX_PKG_BUILDER_DIR/LICENSE $TERMUX_PKG_SRCDIR/
}

termux_step_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/execinfo.h $TERMUX_PREFIX/include/execinfo.h
	install -Dm600 libandroid-execinfo.a $TERMUX_PREFIX/lib/libandroid-execinfo.a
	install -Dm600 libandroid-execinfo.so $TERMUX_PREFIX/lib/libandroid-execinfo.so
	ln -sfr $TERMUX_PREFIX/lib/libandroid-execinfo.so $TERMUX_PREFIX/lib/libexecinfo.so
}
