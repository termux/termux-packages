TERMUX_PKG_HOMEPAGE=http://www.fefe.de/libowfat/
TERMUX_PKG_DESCRIPTION="GPL reimplementation of libdjb"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.32
TERMUX_PKG_SRCURL=http://www.fefe.de/libowfat/libowfat-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=f4b9b3d9922dc25bc93adedf9e9ff8ddbebaf623f14c8e7a5f2301bfef7998c1
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES CROSS="${CC/clang}"
}

termux_step_make_install() {
	make install prefix=$TERMUX_PREFIX LIBDIR=$TERMUX_PREFIX/lib \
		MAN3DIR=$TERMUX_PREFIX/share/man/man3
}
