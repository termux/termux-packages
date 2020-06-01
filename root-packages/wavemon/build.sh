TERMUX_PKG_HOMEPAGE=https://github.com/uoaerg/wavemon
TERMUX_PKG_DESCRIPTION="Ncurses-based monitoring application for wireless network devices"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.9.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/uoaerg/wavemon/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5ebd5b79d3b7c546bc16b95161872c699a75e9acdfc6e3f02ec48dad10802067
TERMUX_PKG_DEPENDS="libcap, libnl, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_pthread_pthread_create=yes"

termux_step_pre_configure() {
	CPPFLAGS+=" -I$TERMUX_PREFIX/include/libnl3"
}
