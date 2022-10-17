TERMUX_PKG_HOMEPAGE=https://www.leonerd.org.uk/code/libvterm/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:0.3
TERMUX_PKG_SRCURL=https://www.leonerd.org.uk/code/libvterm/libvterm-${TERMUX_PKG_VERSION:2:4}.tar.gz
TERMUX_PKG_SHA256=61eb0d6628c52bdf02900dfd4468aa86a1a7125228bab8a67328981887483358
TERMUX_PKG_BREAKS="libvterm-dev"
TERMUX_PKG_REPLACES="libvterm-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make src/encoding/DECdrawing.inc src/encoding/uk.inc
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/src
	$CC -std=c99 -shared -fPIC $LDFLAGS -o $TERMUX_PREFIX/lib/libvterm.so *.c -I../include -I.
	cp ../include/*.h $TERMUX_PREFIX/include/
}
