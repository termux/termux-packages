TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/boinctui/
TERMUX_PKG_DESCRIPTION="curses based manager for Boinc client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/boinctui/files/boinctui_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=22eb46dea8b111e2e16ceb50f2668577216c1563c815b1719b2b680d485d75c9
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libexpat, ncurses, ncurses-ui-libs, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gnutls --mandir=${TERMUX_PREFIX}/share/man"

termux_step_pre_configure() {
	export CFLAGS+=" -flto"
	export CXXFLAGS+=" -flto"
	autoreconf -fi
}
