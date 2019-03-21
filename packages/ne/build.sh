TERMUX_PKG_HOMEPAGE=http://ne.di.unimi.it/
TERMUX_PKG_DESCRIPTION="Easy-to-use and powerful text editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="David Martínez @vaites"
TERMUX_PKG_VERSION=3.1.2
TERMUX_PKG_SHA256=31710ce07d6134355f311b249dcd0a8c99c0075b377bbb78a99ee1338d00c6a3
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/ne-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_RM_AFTER_INSTALL="info/"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	export OPTS="$CFLAGS $CPPFLAGS"
}
