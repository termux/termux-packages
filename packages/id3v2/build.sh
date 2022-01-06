TERMUX_PKG_HOMEPAGE=http://id3v2.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A command line id3v2 tag editor"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.12
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/id3v2/id3v2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8105fad3189dbb0e4cb381862b4fa18744233c3bbe6def6f81ff64f5101722bf
TERMUX_PKG_DEPENDS="id3lib, libc++, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_post_configure() {
	make clean
}
