TERMUX_PKG_HOMEPAGE=https://www.leonerd.org.uk/code/libvterm/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.3.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.leonerd.org.uk/code/libvterm/libvterm-${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=09156f43dd2128bd347cbeebe50d9a571d32c64e0cf18d211197946aff7226e0
TERMUX_PKG_BREAKS="libvterm-dev"
TERMUX_PKG_REPLACES="libvterm-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make src/encoding/DECdrawing.inc src/encoding/uk.inc
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/src
	$CC -std=c99 -shared -fPIC $LDFLAGS -o $TERMUX_PREFIX/lib/libvterm.so \
		-Wl,-soname=libvterm.so *.c -I../include -I.
	cp ../include/*.h $TERMUX_PREFIX/include/
}
