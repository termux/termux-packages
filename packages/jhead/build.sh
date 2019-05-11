TERMUX_PKG_HOMEPAGE=http://www.sentex.net/~mwandel/jhead/
TERMUX_PKG_DESCRIPTION="Exif Jpeg header manipulation tool"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_VERSION=3.03
TERMUX_PKG_SHA256=82194e0128d9141038f82fadcb5845391ca3021d61bc00815078601619f6c0c2
TERMUX_PKG_SRCURL=http://www.sentex.net/~mwandel/jhead/jhead-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install() {
	cp jhead $TERMUX_PREFIX/bin/jhead
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp -f jhead.1 $TERMUX_PREFIX/share/man/man1/jhead.1
}
