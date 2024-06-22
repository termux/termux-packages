TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/boinctui/
TERMUX_PKG_DESCRIPTION="curses based manager for Boinc client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.1"
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/boinctui/files/boinctui_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=44b059a31d1dc4d7125a48bef6c201c08fda599ed22490cbb626880bbd0ccf66
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libexpat, ncurses, ncurses-ui-libs, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gnutls --mandir=${TERMUX_PREFIX}/share/man"

termux_step_pre_configure() {
	export CFLAGS+=" -flto"
	export CXXFLAGS+=" -flto"
	autoreconf -fi
}
