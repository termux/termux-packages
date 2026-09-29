TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/boinctui/
TERMUX_PKG_DESCRIPTION="curses based manager for Boinc client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.2"
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/boinctui/files/boinctui_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6e2ca56e95c321f55e032a539e63dce37298d96b73e8f809101569c41e73ee11
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libexpat, ncurses, ncurses-ui-libs, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gnutls --mandir=${TERMUX_PREFIX}/share/man"

termux_step_pre_configure() {
	export CFLAGS+=" -flto"
	export CXXFLAGS+=" -flto"
	autoreconf -fi
}
