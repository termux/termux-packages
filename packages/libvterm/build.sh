TERMUX_PKG_HOMEPAGE=https://www.leonerd.org.uk/code/libvterm/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:0.3.1
TERMUX_PKG_SRCURL=https://www.leonerd.org.uk/code/libvterm/libvterm-${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=25a8ad9c15485368dfd0a8a9dca1aec8fea5c27da3fa74ec518d5d3787f0c397
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
