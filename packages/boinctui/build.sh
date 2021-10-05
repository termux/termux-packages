TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/boinctui/
TERMUX_PKG_DESCRIPTION="curses based manager for Boinc client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.1
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/boinctui/files/boinctui_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=319f539535f3af342ec0bafc5228673bf12f2d7a7addf5851f2c003200e51da9
TERMUX_PKG_DEPENDS="glib, libandroid-support, libexpat, ncurses, ncurses-ui-libs, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gnutls --mandir=$TERMUX_PREFIX/share/man"

termux_step_pre_configure() {
	CPPFLAGS+=" -DANDROID"
	LDFLAGS+=" -llog"
	autoconf
}
