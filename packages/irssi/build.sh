TERMUX_PKG_HOMEPAGE=http://www.irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client for UNIX systems"
TERMUX_PKG_DEPENDS="ncurses, openssl, glib, libandroid-glob"
TERMUX_PKG_VERSION=0.8.20
TERMUX_PKG_SRCURL=https://github.com/irssi/irssi/releases/download/${TERMUX_PKG_VERSION}/irssi-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_FOLDERNAME=irssi-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_RM_AFTER_INSTALL=share/irssi/scripts # perl scripts

termux_step_pre_configure () {
	LDFLAGS+=" -landroid-glob"
}
