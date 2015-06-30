TERMUX_PKG_HOMEPAGE=http://www.irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client for UNIX systems"
TERMUX_PKG_DEPENDS="ncurses, openssl, glib, libandroid-glob"
TERMUX_PKG_VERSION=0.8.17
# 2015-06-30: Using mirror since main site down:
# TERMUX_PKG_SRCURL=http://www.irssi.org/files/irssi-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://fossies.org/linux/privat/irssi-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_RM_AFTER_INSTALL=share/irssi/scripts # perl scripts

termux_step_pre_configure () {
	LDFLAGS+=" -landroid-glob"
}
