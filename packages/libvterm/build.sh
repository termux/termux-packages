TERMUX_PKG_HOMEPAGE=http://libvterm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
# libvterm does not do releases, take a specific commit for now:
TERMUX_PKG_VERSION=19.09.17
TERMUX_PKG_REVISION=1
_COMMIT=fcbccd3c79bfa811800fea24db3a77384941cb70
TERMUX_PKG_SRCURL=https://github.com/neovim/libvterm/archive/$_COMMIT.zip
TERMUX_PKG_SHA256=a20ebb18f37dccc685d8518147a0db78280582138ebc76e2635830cd93572bde
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
