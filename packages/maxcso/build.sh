TERMUX_PKG_HOMEPAGE=https://github.com/unknownbrackets/maxcso
TERMUX_PKG_DESCRIPTION="A fast ISO to CSO compression program for use with PSP and PS2 emulators"
TERMUX_PKG_LICENSE="ISC, LGPL-2.1, Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.md, README.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.13.0
TERMUX_PKG_SRCURL=https://github.com/unknownbrackets/maxcso/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=af9c05add1a1d199ec184d3471081af1b91d591b2473800ea989c882fb632730
TERMUX_PKG_DEPENDS="libc++, liblz4, libuv, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	CXXFLAGS+=" $CPPFLAGS"
}

termux_step_post_make_install() {
	install -Dm600 -T $TERMUX_PKG_SRCDIR/7zip/DOC/License.txt \
		$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING.7zip
	install -Dm600 -T $TERMUX_PKG_SRCDIR/libdeflate/COPYING \
		$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING.libdeflate
	install -Dm600 -T $TERMUX_PKG_SRCDIR/zopfli/COPYING \
		$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING.zopfli
}
