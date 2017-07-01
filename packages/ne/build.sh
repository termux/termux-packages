TERMUX_PKG_HOMEPAGE=http://ne.di.unimi.it/
TERMUX_PKG_DESCRIPTION="Easy-to-use and powerful text editor"
TERMUX_PKG_MAINTAINER="David Martínez @vaites"
TERMUX_PKG_VERSION=3.1.1
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/ne-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=361aeeda179ac2904efe35f0c5d4c90e6e9a246485ddd9fa6fb74581803435e2
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_RM_AFTER_INSTALL="info/"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	export OPTS="$CFLAGS $CPPFLAGS"
}
