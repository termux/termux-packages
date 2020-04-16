TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/boinctui/
TERMUX_PKG_DESCRIPTION="curses based manager for Boinc client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/boinctui/files/boinctui_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="173dd1231b29eaf5357fa5de612dbce231537c40e631d598a2f49a4f32bafd9b"
TERMUX_PKG_DEPENDS="glib, libandroid-support, libexpat, ncurses, ncurses-ui-libs, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gnutls"

termux_step_pre_configure() {
	CPPFLAGS+=" -DANDROID"
	LDFLAGS+=" -llog"
	autoconf
}
