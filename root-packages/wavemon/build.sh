TERMUX_PKG_HOMEPAGE=https://github.com/uoaerg/wavemon
TERMUX_PKG_DESCRIPTION="Ncurses-based monitoring application for wireless network devices"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.5"
TERMUX_PKG_SRCURL=https://github.com/uoaerg/wavemon/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f84c55a40b470f2b98908d20cd0b38ffef6f587daed23b50281c9592df3331c6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcap, libnl, libnl-cli, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_pthread_pthread_create=yes"

termux_step_pre_configure() {
	CPPFLAGS+=" -I$TERMUX_PREFIX/include/libnl3"
}
