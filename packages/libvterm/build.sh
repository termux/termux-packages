TERMUX_PKG_HOMEPAGE=https://www.leonerd.org.uk/code/libvterm/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:0.3.2
TERMUX_PKG_SRCURL=https://www.leonerd.org.uk/code/libvterm/libvterm-${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=91eb5088069f4e6edab69e14c4212f6da0192e65695956dc048016a0dab8bcf6
TERMUX_PKG_BREAKS="libvterm-dev"
TERMUX_PKG_REPLACES="libvterm-dev"
TERMUX_PKG_EXTRA_MAKE_ARGS="src/encoding/DECdrawing.inc src/encoding/uk.inc"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	cd src
	$CC -std=c99 -shared -fPIC $LDFLAGS -o \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/libvterm.so \
		-Wl,-soname=libvterm.so *.c -I../include -I.
	install -m600 ../include/*.h $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/
}
